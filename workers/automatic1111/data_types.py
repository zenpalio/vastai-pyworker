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
    ad_cfg_scale: Optional[int] = None
    ad_checkpoint: Optional[str] = None
    ad_clip_skip: Optional[int] = None
    ad_confidence: Optional[float] = None
    ad_controlnet_guidance_end: Optional[int] = None
    ad_controlnet_guidance_start: Optional[int] = None
    ad_controlnet_model: Optional[str] = None
    ad_controlnet_module: Optional[str] = None
    ad_controlnet_weight: Optional[int] = None
    ad_denoising_strength: Optional[float] = None
    ad_dilate_erode: Optional[int] = None
    ad_inpaint_height: Optional[int] = None
    ad_inpaint_only_masked: Optional[bool] = None
    ad_inpaint_only_masked_padding: Optional[int] = None
    ad_inpaint_width: Optional[int] = None
    ad_mask_blur: Optional[int] = None
    ad_mask_k_largest: Optional[int] = None
    ad_mask_max_ratio: Optional[int] = None
    ad_mask_merge_invert: Optional[str] = None
    ad_mask_min_ratio: Optional[int] = None
    ad_model: Optional[str] = None
    ad_model_classes: Optional[str] = None
    ad_negative_prompt: Optional[str] = None
    ad_noise_multiplier: Optional[int] = None
    ad_prompt: Optional[str] = None
    ad_restore_face: Optional[bool] = None
    ad_sampler: Optional[str] = None
    ad_scheduler: Optional[str] = None
    ad_steps: Optional[int] = None
    ad_tab_enable: Optional[bool] = None
    ad_use_cfg_scale: Optional[bool] = None
    ad_use_checkpoint: Optional[bool] = None
    ad_use_clip_skip: Optional[bool] = None
    ad_use_inpaint_width_height: Optional[bool] = None
    ad_use_noise_multiplier: Optional[bool] = None
    ad_use_sampler: Optional[bool] = None
    ad_use_steps: Optional[bool] = None
    ad_use_vae: Optional[bool] = None
    ad_vae: Optional[str] = None
    ad_x_offset: Optional[int] = None
    ad_y_offset: Optional[int] = None
    is_api: Optional[List[Any]] = None


@dataclass
class ADetailer:
    args: Optional[List[Union[bool, ADetailerArgs]]] = None


@dataclass
class ControlNetArgs:
    advanced_weighting: Optional[Any] = None
    animatediff_batch: Optional[bool] = None
    batch_image_files: Optional[List[str]] = None
    batch_images: Optional[str] = None
    batch_keyframe_idx: Optional[Any] = None
    batch_mask_dir: Optional[Any] = None
    batch_modifiers: Optional[List[str]] = None
    control_mode: Optional[str] = None
    effective_region_mask: Optional[Any] = None
    enabled: Optional[bool] = None
    guidance_end: Optional[float] = None
    guidance_start: Optional[float] = None
    hr_option: Optional[str] = None
    image: Optional[Any] = None
    inpaint_crop_input_image: Optional[bool] = None
    input_mode: Optional[str] = None
    ipadapter_input: Optional[Any] = None
    is_ui: Optional[bool] = None
    loopback: Optional[bool] = None
    low_vram: Optional[bool] = None
    mask: Optional[Any] = None
    model: Optional[str] = None
    module: Optional[str] = None
    output_dir: Optional[str] = None
    pixel_perfect: Optional[bool] = None
    processor_res: Optional[int] = None
    pulid_mode: Optional[str] = None
    resize_mode: Optional[str] = None
    save_detected_map: Optional[bool] = None
    threshold_a: Optional[float] = None
    threshold_b: Optional[float] = None
    union_control_type: Optional[str] = None
    weight: Optional[float] = None


@dataclass
class ControlNet:
    args: Optional[List[ControlNetArgs]] = None


@dataclass
class DynamicPrompts:
    args: Optional[List[Union[bool, int, float, str, List[bool]]]] = None


@dataclass
class FaceEditorEX:
    args: Optional[List[Union[bool, float, int, str, List[str], Dict[str, Any]]]] = None


@dataclass
class ReActor:
    args: Optional[List[Union[None, bool, str, float, int, Dict[str, Any]]]] = None


@dataclass
class Refiner:
    args: Optional[List[Union[bool, str, float]]] = None


@dataclass
class RegionalPrompter:
    args: Optional[List[Union[bool, str, List[bool], float, None]]] = None


@dataclass
class Sampler:
    args: Optional[List[Union[int, str]]] = None


@dataclass
class Seed:
    args: Optional[List[Union[int, bool, float]]] = None


@dataclass
class AlwaysOnScripts:
    ADetailer: Optional[ADetailer] = None
    API_payload: Optional[Dict[str, List[Any]]] = None
    Comments: Optional[Dict[str, List[Any]]] = None
    ControlNet: Optional[ControlNet] = None
    Dynamic_Prompts_v2_17_1: Optional[DynamicPrompts] = None
    Extra_options: Optional[Dict[str, List[Any]]] = None
    Face_Editor_EX: Optional[FaceEditorEX] = None
    Hypertile: Optional[Dict[str, List[Any]]] = None
    ReActor: Optional[ReActor] = None
    Refiner: Optional[Refiner] = None
    Regional_Prompter: Optional[RegionalPrompter] = None
    Sampler: Optional[Sampler] = None
    Seed: Optional[Seed] = None


@dataclass
class InputData:
    alwayson_scripts: Optional[AlwaysOnScripts] = None
    batch_size: Optional[int] = None
    cfg_scale: Optional[int] = None
    comments: Optional[Dict[str, Any]] = None
    denoising_strength: Optional[float] = None
    disable_extra_networks: Optional[bool] = None
    do_not_save_grid: Optional[bool] = None
    do_not_save_samples: Optional[bool] = None
    enable_hr: Optional[bool] = None
    height: Optional[int] = None
    hr_negative_prompt: Optional[str] = None
    hr_prompt: Optional[str] = None
    hr_resize_x: Optional[int] = None
    hr_resize_y: Optional[int] = None
    hr_scale: Optional[int] = None
    hr_scheduler: Optional[str] = None
    hr_second_pass_steps: Optional[int] = None
    hr_upscaler: Optional[str] = None
    n_iter: Optional[int] = None
    negative_prompt: Optional[str] = None
    override_settings: Optional[Dict[str, int]] = None
    override_settings_restore_afterwards: Optional[bool] = None
    prompt: Optional[str] = None
    restore_faces: Optional[bool] = None
    s_churn: Optional[float] = None
    s_min_uncond: Optional[float] = None
    s_noise: Optional[float] = None
    s_tmax: Optional[Any] = None
    s_tmin: Optional[float] = None
    sampler_name: Optional[str] = None
    scheduler: Optional[str] = None
    script_args: Optional[List[Any]] = None
    script_name: Optional[Any] = None
    seed: Optional[int] = None
    seed_enable_extras: Optional[bool] = None
    seed_resize_from_h: Optional[int] = None
    seed_resize_from_w: Optional[int] = None
    steps: Optional[int] = None
    styles: Optional[List[Any]] = None
    subseed: Optional[int] = None
    subseed_strength: Optional[float] = None
    tiling: Optional[bool] = None
    width: Optional[int] = None

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
    max_new_tokens: Optional[int] = 256

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
