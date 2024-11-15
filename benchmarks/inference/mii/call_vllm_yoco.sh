#!/bin/bash

curl -X POST http://127.0.0.1:26500/generate \
   -H 'Content-Type: application/json' \
   -d '{"prompt":"we are so alike we finish each others","n": 1, "temperature": 1.0, "top_p": 0.95, "max_tokens": 128, "ignore_eos": true, "stream": true}'