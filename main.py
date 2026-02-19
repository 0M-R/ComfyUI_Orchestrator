import os
import json
import random
import requests

PORT = 8188
SERVER = f"http://127.0.0.1:{PORT}/prompt"

MODEL_FOLDER = "model/1"
PRINT_FOLDER = "prints"
OUTPUT_FOLDER = "output"
PROMPT_FILE = "prompts/print.txt"
WORKFLOW_FILE = "workflows/print.json"

MODE = "all"   # "all" or "one"

with open(WORKFLOW_FILE, "r") as f:
    workflow = json.load(f)

with open(PROMPT_FILE, "r") as f:
    prompt_text = f.read().strip()

models = sorted([
    f for f in os.listdir(MODEL_FOLDER)
    if f.lower().endswith((".png", ".jpg", ".jpeg"))
])

prints = sorted([
    f for f in os.listdir(PRINT_FOLDER)
    if f.lower().endswith((".png", ".jpg", ".jpeg"))
])


def generate(model_img, print_img):
    seed = random.randint(1, 999999999)

    model_path = os.path.join(MODEL_FOLDER, model_img)
    print_path = os.path.join(PRINT_FOLDER, print_img)

    filename = f"{os.path.splitext(model_img)[0]}_{os.path.splitext(print_img)[0]}"

    #  Direct API format editing
    workflow["76"]["inputs"]["image"] = model_path
    workflow["81"]["inputs"]["image"] = print_path
    workflow["107"]["inputs"]["text"] = prompt_text
    workflow["104"]["inputs"]["noise_seed"] = seed
    workflow["94"]["inputs"]["filename_prefix"] = os.path.join(OUTPUT_FOLDER, filename)

    payload = {
        "prompt": workflow,
        "client_id": "atm_generator"
    }

    response = requests.post(SERVER, json=payload)
    print("Queued:", filename, "|", response.text)


if MODE == "one":
    for m, p in zip(models, prints):
        generate(m, p)
else:
    for m in models:
        for p in prints:
            generate(m, p)

print("Done.")
