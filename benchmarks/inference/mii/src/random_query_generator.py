# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: Apache-2.0

# DeepSpeed Team

import numpy as np
import torch
import random
import os
import base64
from io import BytesIO
from PIL import Image

class RandomQueryGenerator:
    def __init__(self, input_text, tokenizer, seed, image_dir=None):
        self.input_text = input_text
        self.tokenizer = tokenizer
        self.image_dir = image_dir

        torch.manual_seed(seed)
        random.seed(seed)
        np.random.seed(seed)

    def get_random_request_text(self, length, variance, max_length, batch):
        request_text = []
        tokenized_input = self.tokenizer.batch_encode_plus(
            [self.input_text], return_tensors="pt", padding=False
        )
        offset = list(range(512))
        random.shuffle(offset)

        text_ids = tokenized_input["input_ids"][0]
        for i in range(batch):
            # Set max_new_tokens following normal distribution with mean=max_new_tokens and std=0.3*max_new_tokens
            req_prompt_length = min(int(np.random.normal(length, variance)), max_length)

            text = self.tokenizer.decode(text_ids[i : req_prompt_length + i])

            if self.image_dir:
                images = os.listdir(self.image_dir)
                if images:
                    selected_image = random.choice(images)
                    buffered = BytesIO()
                    Image.open(os.path.join(self.image_dir, selected_image)).save(buffered, format="JPEG")
                    # Encode the BytesIO object to base64
                    img_str = base64.b64encode(buffered.getvalue()).decode('utf-8')

                    messages = [{ "role": "user", "content": [
                            {
                                "type": "text",
                                "text": text
                            },
                            {
                                "type": "image_url",
                                "image_url": {
                                            "url": f"data:image/jpeg;base64,{img_str}"
                                        },
                            },
                        ],
                    }]
                    request_text.append(messages)
            else:
                request_text.append(text)
        return request_text
