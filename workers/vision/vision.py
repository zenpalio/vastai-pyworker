import torch
from PIL import Image
from transformers import MllamaForConditionalGeneration, AutoProcessor
from transformers import BitsAndBytesConfig
from peft import PeftModel, PeftConfig
from typing import Optional, Tuple, Any
import aiohttp
import io


class Vision:
    def __init__(self):
        self.model = None
        self.processor = None

    def load_vision_model(self) -> None:
        bnb_config = BitsAndBytesConfig(
            load_in_4bit=True,
            bnb_4bit_use_double_quant=True,
            bnb_4bit_quant_type="nf4",
            bnb_4bit_compute_dtype=torch.bfloat16,
        )

        model_id = "alpindale/Llama-3.2-11B-Vision-Instruct"

        model = MllamaForConditionalGeneration.from_pretrained(
            model_id, quantization_config=bnb_config, device_map="cuda", do_sample=False
        )
        config = PeftConfig.from_pretrained(
            "Guilherme34/Llama-3.2-11b-vision-uncensored"
        )
        self.processor = AutoProcessor.from_pretrained(model_id)
        self.model = PeftModel.from_pretrained(
            model, "Guilherme34/Llama-3.2-11b-vision-uncensored"
        )

    async def generate_tags_for_image(
        self, image_url: str, system_prompt: str, prompt: str
    ) -> Any:

        async with aiohttp.ClientSession() as session:
            async with session.get(image_url) as response:
                image_data = await response.read()
                image = Image.open(io.BytesIO(image_data))
        messages = [
            {
                "role": "SYS",
                "content": [
                    {
                        "type": "text",
                        "text": system_prompt,
                    }
                ],
            },
            {
                "role": "assistant",
                "content": [{"type": "text", "text": "ok, you piece of shit"}],
            },
            {
                "role": "user",
                "content": [{"type": "image"}, {"type": "text", "text": prompt}],
            },
        ]
        input_text = self.processor.apply_chat_template(
            messages, add_generation_prompt=True
        )
        inputs = self.processor(image, input_text, return_tensors="pt").to(
            self.model.device
        )

        output = self.model.generate(**inputs, max_new_tokens=256)
        return self.processor.decode(output[0])
