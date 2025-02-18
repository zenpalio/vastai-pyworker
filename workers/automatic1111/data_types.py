import dataclasses
import inspect

import json

from lib.data_types import JsonDataException

from dataclasses import dataclass
from typing import List, Optional, Union, Dict, Any


@dataclass
class ADetailerArgs:
    ad_cfg_scale: Optional[int] = 0
    ad_checkpoint: Optional[str] = ""
    ad_clip_skip: Optional[int] = 0
    ad_confidence: Optional[float] = 0.0
    ad_controlnet_guidance_end: Optional[int] = 0
    ad_controlnet_guidance_start: Optional[int] = 0
    ad_controlnet_model: Optional[str] = ""
    ad_controlnet_module: Optional[str] = ""
    ad_controlnet_weight: Optional[int] = 0
    ad_denoising_strength: Optional[float] = 0.0
    ad_dilate_erode: Optional[int] = 0
    ad_inpaint_height: Optional[int] = 0
    ad_inpaint_only_masked: Optional[bool] = False
    ad_inpaint_only_masked_padding: Optional[int] = 0
    ad_inpaint_width: Optional[int] = 0
    ad_mask_blur: Optional[int] = 0
    ad_mask_k_largest: Optional[int] = 0
    ad_mask_max_ratio: Optional[int] = 0
    ad_mask_merge_invert: Optional[str] = ""
    ad_mask_min_ratio: Optional[int] = 0
    ad_model: Optional[str] = ""
    ad_model_classes: Optional[str] = ""
    ad_negative_prompt: Optional[str] = ""
    ad_noise_multiplier: Optional[int] = 0
    ad_prompt: Optional[str] = ""
    ad_restore_face: Optional[bool] = False
    ad_sampler: Optional[str] = ""
    ad_scheduler: Optional[str] = ""
    ad_steps: Optional[int] = 0
    ad_tab_enable: Optional[bool] = False
    ad_use_cfg_scale: Optional[bool] = False
    ad_use_checkpoint: Optional[bool] = False
    ad_use_clip_skip: Optional[bool] = False
    ad_use_inpaint_width_height: Optional[bool] = False
    ad_use_noise_multiplier: Optional[bool] = False
    ad_use_sampler: Optional[bool] = False
    ad_use_steps: Optional[bool] = False
    ad_use_vae: Optional[bool] = False
    ad_vae: Optional[str] = ""
    ad_x_offset: Optional[int] = 0
    ad_y_offset: Optional[int] = 0
    is_api: Optional[List[Any]] = dataclasses.field(default_factory=list)


@dataclass
class ADetailer:
    args: Optional[List[Union[bool, ADetailerArgs]]] = dataclasses.field(
        default_factory=list
    )


@dataclass
class ControlNetArgs:
    advanced_weighting: Optional[Any] = None
    animatediff_batch: Optional[bool] = False
    batch_image_files: Optional[List[str]] = dataclasses.field(default_factory=list)
    batch_images: Optional[str] = ""
    batch_keyframe_idx: Optional[Any] = None
    batch_mask_dir: Optional[Any] = None
    batch_modifiers: Optional[List[str]] = dataclasses.field(default_factory=list)
    control_mode: Optional[str] = ""
    effective_region_mask: Optional[Any] = None
    enabled: Optional[bool] = False
    guidance_end: Optional[float] = 0.0
    guidance_start: Optional[float] = 0.0
    hr_option: Optional[str] = ""
    image: Optional[Any] = None
    inpaint_crop_input_image: Optional[bool] = False
    input_mode: Optional[str] = ""
    ipadapter_input: Optional[Any] = None
    is_ui: Optional[bool] = False
    loopback: Optional[bool] = False
    low_vram: Optional[bool] = False
    mask: Optional[Any] = None
    model: Optional[str] = ""
    module: Optional[str] = ""
    output_dir: Optional[str] = ""
    pixel_perfect: Optional[bool] = False
    processor_res: Optional[int] = 0
    pulid_mode: Optional[str] = ""
    resize_mode: Optional[str] = ""
    save_detected_map: Optional[bool] = False
    threshold_a: Optional[float] = 0.0
    threshold_b: Optional[float] = 0.0
    union_control_type: Optional[str] = ""
    weight: Optional[float] = 0.0


@dataclass
class ControlNet:
    args: Optional[List[ControlNetArgs]] = dataclasses.field(default_factory=list)


@dataclass
class DynamicPrompts:
    args: Optional[List[Union[bool, int, float, str, List[bool]]]] = dataclasses.field(
        default_factory=list
    )


@dataclass
class FaceEditorEX:
    args: Optional[List[Union[bool, float, int, str, List[str], Dict[str, Any]]]] = (
        dataclasses.field(default_factory=list)
    )


@dataclass
class ReActor:
    args: Optional[List[Union[None, bool, str, float, int, Dict[str, Any]]]] = (
        dataclasses.field(default_factory=list)
    )


@dataclass
class Refiner:
    args: Optional[List[Union[bool, str, float]]] = dataclasses.field(
        default_factory=list
    )


@dataclass
class RegionalPrompter:
    args: Optional[List[Union[bool, str, List[bool], float, None]]] = dataclasses.field(
        default_factory=list
    )


@dataclass
class Sampler:
    args: Optional[List[Union[int, str]]] = dataclasses.field(default_factory=list)


@dataclass
class Seed:
    args: Optional[List[Union[int, bool, float]]] = dataclasses.field(
        default_factory=list
    )


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
    batch_size: Optional[int] = 0
    cfg_scale: Optional[int] = 0
    comments: Optional[Dict[str, Any]] = None
    denoising_strength: Optional[float] = 0.0
    disable_extra_networks: Optional[bool] = False
    do_not_save_grid: Optional[bool] = False
    do_not_save_samples: Optional[bool] = False
    enable_hr: Optional[bool] = False
    height: Optional[int] = 0
    hr_negative_prompt: Optional[str] = ""
    hr_prompt: Optional[str] = ""
    hr_resize_x: Optional[int] = 0
    hr_resize_y: Optional[int] = 0
    hr_scale: Optional[int] = 0
    hr_scheduler: Optional[str] = ""
    hr_second_pass_steps: Optional[int] = 0
    hr_upscaler: Optional[str] = ""
    n_iter: Optional[int] = 0
    negative_prompt: Optional[str] = ""
    override_settings: Optional[Dict[str, int]] = None
    override_settings_restore_afterwards: Optional[bool] = False
    prompt: Optional[str] = ""
    restore_faces: Optional[bool] = False
    s_churn: Optional[float] = 0.0
    s_min_uncond: Optional[float] = 0.0
    s_noise: Optional[float] = 0.0
    s_tmax: Optional[Any] = None
    s_tmin: Optional[float] = 0.0
    sampler_name: Optional[str] = ""
    scheduler: Optional[str] = ""
    script_args: Optional[List[Any]] = dataclasses.field(default_factory=list)
    script_name: Optional[Any] = None
    seed: Optional[int] = 0
    seed_enable_extras: Optional[bool] = False
    seed_resize_from_h: Optional[int] = 0
    seed_resize_from_w: Optional[int] = 0
    steps: Optional[int] = 0
    styles: Optional[List[Any]] = dataclasses.field(default_factory=list)
    subseed: Optional[int] = 0
    subseed_strength: Optional[float] = 0.0
    tiling: Optional[bool] = False
    width: Optional[int] = 0

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
