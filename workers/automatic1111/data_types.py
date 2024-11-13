import dataclasses
import random
import inspect

from transformers import AutoTokenizer
import nltk

from lib.data_types import ApiPayload, JsonDataException

from dataclasses import dataclass
from typing import List, Optional, Union, Dict, Any


@dataclass
class ADetailerArgs:
    ad_cfg_scale: int
    ad_checkpoint: str
    ad_clip_skip: int
    ad_confidence: float
    ad_controlnet_guidance_end: int
    ad_controlnet_guidance_start: int
    ad_controlnet_model: str
    ad_controlnet_module: str
    ad_controlnet_weight: int
    ad_denoising_strength: float
    ad_dilate_erode: int
    ad_inpaint_height: int
    ad_inpaint_only_masked: bool
    ad_inpaint_only_masked_padding: int
    ad_inpaint_width: int
    ad_mask_blur: int
    ad_mask_k_largest: int
    ad_mask_max_ratio: int
    ad_mask_merge_invert: str
    ad_mask_min_ratio: int
    ad_model: str
    ad_model_classes: str
    ad_negative_prompt: str
    ad_noise_multiplier: int
    ad_prompt: str
    ad_restore_face: bool
    ad_sampler: str
    ad_scheduler: str
    ad_steps: int
    ad_tab_enable: bool
    ad_use_cfg_scale: bool
    ad_use_checkpoint: bool
    ad_use_clip_skip: bool
    ad_use_inpaint_width_height: bool
    ad_use_noise_multiplier: bool
    ad_use_sampler: bool
    ad_use_steps: bool
    ad_use_vae: bool
    ad_vae: str
    ad_x_offset: int
    ad_y_offset: int
    is_api: List[Any]


@dataclass
class ADetailer:
    args: List[Union[bool, ADetailerArgs]]


@dataclass
class ControlNetArgs:
    advanced_weighting: Optional[Any]
    animatediff_batch: bool
    batch_image_files: List[str]
    batch_images: str
    batch_keyframe_idx: Optional[Any]
    batch_mask_dir: Optional[Any]
    batch_modifiers: List[str]
    control_mode: str
    effective_region_mask: Optional[Any]
    enabled: bool
    guidance_end: float
    guidance_start: float
    hr_option: str
    image: Optional[Any]
    inpaint_crop_input_image: bool
    input_mode: str
    ipadapter_input: Optional[Any]
    is_ui: bool
    loopback: bool
    low_vram: bool
    mask: Optional[Any]
    model: str
    module: str
    output_dir: str
    pixel_perfect: bool
    processor_res: int
    pulid_mode: str
    resize_mode: str
    save_detected_map: bool
    threshold_a: float
    threshold_b: float
    union_control_type: str
    weight: float


@dataclass
class ControlNet:
    args: List[ControlNetArgs]


@dataclass
class DynamicPrompts:
    args: List[Union[bool, int, float, str, List[bool]]]


@dataclass
class FaceEditorEX:
    args: List[Union[bool, float, int, str, List[str], Dict[str, Any]]]


@dataclass
class ReActor:
    args: List[Union[None, bool, str, float, int, Dict[str, Any]]]


@dataclass
class Refiner:
    args: List[Union[bool, str, float]]


@dataclass
class RegionalPrompter:
    args: List[Union[bool, str, List[bool], float, None]]


@dataclass
class Sampler:
    args: List[Union[int, str]]


@dataclass
class Seed:
    args: List[Union[int, bool, float]]


@dataclass
class AlwaysOnScripts:
    ADetailer: ADetailer
    API_payload: Dict[str, List[Any]]
    Comments: Dict[str, List[Any]]
    ControlNet: ControlNet
    Dynamic_Prompts_v2_17_1: DynamicPrompts
    Extra_options: Dict[str, List[Any]]
    Face_Editor_EX: FaceEditorEX
    Hypertile: Dict[str, List[Any]]
    ReActor: ReActor
    Refiner: Refiner
    Regional_Prompter: RegionalPrompter
    Sampler: Sampler
    Seed: Seed


@dataclass
class InputData:
    alwayson_scripts: AlwaysOnScripts
    batch_size: int
    cfg_scale: int
    comments: Dict[str, Any]
    denoising_strength: float
    disable_extra_networks: bool
    do_not_save_grid: bool
    do_not_save_samples: bool
    enable_hr: bool
    height: int
    hr_negative_prompt: str
    hr_prompt: str
    hr_resize_x: int
    hr_resize_y: int
    hr_scale: int
    hr_scheduler: str
    hr_second_pass_steps: int
    hr_upscaler: str
    n_iter: int
    negative_prompt: str
    override_settings: Dict[str, int]
    override_settings_restore_afterwards: bool
    prompt: str
    restore_faces: bool
    s_churn: float
    s_min_uncond: float
    s_noise: float
    s_tmax: Optional[Any]
    s_tmin: float
    sampler_name: str
    scheduler: str
    script_args: List[Any]
    script_name: Optional[Any]
    seed: int
    seed_enable_extras: bool
    seed_resize_from_h: int
    seed_resize_from_w: int
    steps: int
    styles: List[Any]
    subseed: int
    subseed_strength: float
    tiling: bool
    width: int

    def generate_payload_json(self) -> Dict[str, Any]:
        return dataclasses.asdict(self)

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
