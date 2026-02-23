# ** This program is in beta phase **
# ComfyUI_Orchestrator

ComfyUI_Orchestrator is a lightweight local orchestration layer for ComfyUI that automates workflow execution, manages batch jobs, and enables scalable generation of multiple images programmatically via the ComfyUI API.

It allows developers to run ComfyUI workflows headlessly without interacting with the UI, making it ideal for automation pipelines, batch generation, and local inference workflows.

---

## Requirements

This tool requires ComfyUI to be installed and running locally before use.

* Python 3.9+
* ComfyUI installed locally
* Running ComfyUI server
* CUDA-enabled GPU (recommended)

### Install ComfyUI first

Official ComfyUI repository:
https://github.com/comfyanonymous/ComfyUI

```bash
git clone https://github.com/comfyanonymous/ComfyUI
cd ComfyUI
pip install -r requirements.txt
```

---

## Features

* Headless ComfyUI workflow execution
* Batch image generation
* Local orchestration of ComfyUI jobs
* API-driven workflow automation
* Lightweight and script-friendly
* Compatible with existing ComfyUI workflows

---

## Installation

### Clone repository

```bash
git clone https://github.com/0M-R/ComfyUI_Orchestrator
cd ComfyUI_Orchestrator
```

### Install dependencies

```bash
pip install -r requirements.txt
```

---

## Usage

### Start ComfyUI server

```bash
cd ComfyUI
python main.py --listen 0.0.0.0 --port 8188
```

### Run orchestrator

```bash
python main.py
```

---

## Batch Generation
![alt text](https://github.com/0M-R/ComfyUI_Orchestrator/blob/main/1.png)

The orchestrator can execute workflows multiple times to generate batches of images automatically using the ComfyUI API.

---

## Configuration

Edit the following variables in `main.py` if needed:

* ComfyUI server address
* Workflow file path
* Batch size / mode
* Output directory

---

## Project Structure

```
ComfyUI_Orchestrator/
│
├── main.py
├── Workflow.json
├── requirements.txt
├── output/
└── README.md
```

---

## How it works

1. ComfyUI runs locally as a backend server
2. The orchestrator sends workflow requests via API
3. Jobs are queued automatically
4. Generated images are saved locally

---

## Notes

* ComfyUI must be running before executing the orchestrator
* Supports any valid ComfyUI workflow JSON
* Works fully offline on local hardware

---

## License

MIT
