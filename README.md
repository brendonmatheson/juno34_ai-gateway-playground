# Introduction

This project is an attempt to make an easy to follow technical demonstration of [Azure API Management]() covering the specialized role of being an [AI Gateway]() that covers being a:
- Model Gateway
- Agent Gateway
- MCP Tool Gateway

# Methodology

This project takes the approach of using a Jupyter notebook to drive the technical demonstration so that you can click through step by step in a linear fashion, inspecting the technical details at each step.

Where we need to create infrastructure on Azure, we use Terraform rather than Python SDK or Azure CLI calls so that if you want to adapt the templates to your own project, you can.  The Terraform stacks are also deployed from the Jupyter notebook for the purposes of this demonstration piece.

# Getting Started

All tools that you need for this demo are covered by the Dev Container configuration.  All you need is Visual Studio Code.  Just clone the repository and launch the Dev Container.
