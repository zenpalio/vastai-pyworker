import dataclasses
import json
import random
import inspect
from typing import Dict, Any

from transformers import AutoTokenizer
import nltk

from lib.data_types import ApiPayload, JsonDataException

nltk.download("words")
WORD_LIST = nltk.corpus.words.words()

tokenizer = AutoTokenizer.from_pretrained("openai-community/openai-gpt")


@dataclasses.dataclass
class InputParameters:
    max_new_tokens: int = 256

    @classmethod
    def from_json_msg(cls, json_msg: Dict[str, Any]) -> "InputParameters":
        errors = {}
        for param in inspect.signature(cls).parameters:
            if param not in json_msg:
                errors[param] = "missing parameter"
        if errors:
            raise JsonDataException(errors)
        return cls(
            **{
                k: v
                for k, v in json_msg.items()
                if k in inspect.signature(cls).parameters
            }
        )


@dataclasses.dataclass
class InputData(ApiPayload):

    def generate_payload_json(self) -> Dict[str, Any]:
        return json.dumps(dataclasses.asdict(self)).encode("utf-8")

    def count_workload(self) -> int:
        return self.batch_size

    @classmethod
    def from_json_msg(cls, json_msg: Dict[str, Any]) -> "InputData":
        return cls(
            **{
                k: v
                for k, v in json_msg.items()
                if k in inspect.signature(cls).parameters
            }
        )
