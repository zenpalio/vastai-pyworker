import dataclasses
import inspect
from typing import Dict, Any


from lib.data_types import ApiPayload, JsonDataException


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
        return dataclasses.asdict(self)

    def count_workload(self) -> int:
        return 1

    @classmethod
    def from_json_msg(cls, json_msg: Dict[str, Any]) -> "InputData":
        return cls(
            **{
                k: v
                for k, v in json_msg.items()
                if k in inspect.signature(cls).parameters
            }
        )
