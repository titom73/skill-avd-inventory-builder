"""Minimal PyAVD "hello world" example.

This script shows the end-to-end flow:
- Define a small fabric design intent as a Python dict
- Validate the inputs using PyAVD
- Generate AVD facts
- Build the structured configuration for one device
- Render the final EOS CLI configuration

To run this example you must install pyavd in your environment, for example:

    pip install pyavd

Then execute:

    python docs/examples/pyavd_hello_world.py
"""

from __future__ import annotations

from pyavd import (
    get_avd_facts,
    get_device_config,
    get_device_structured_config,
    validate_inputs,
)


def main() -> None:
    """Run a minimal PyAVD pipeline for a 1-spine / 1-leaf fabric."""

    # 1. Define network intent (high-level design)
    design_intent = {
        "fabric_name": "EXAMPLE_FABRIC",
        "spine": {
            "defaults": {"platform": "vEOS-lab", "bgp_as": "65000"},
            "nodes": [
                {"name": "spine1", "id": 1, "mgmt_ip": "192.168.0.10/24"},
            ],
        },
        "l3leaf": {
            "defaults": {
                "platform": "vEOS-lab",
                "loopback_ipv4_pool": "10.255.0.0/27",
                "vtep_loopback_ipv4_pool": "10.255.1.0/27",
            },
            "node_groups": [
                {
                    "group": "LEAF1",
                    "bgp_as": "65001",
                    "nodes": [
                        {
                            "name": "leaf1",
                            "id": 1,
                            "mgmt_ip": "192.168.0.11/24",
                        }
                    ],
                }
            ],
        },
    }

    # 2. Validate the design against the PyAVD schemas
    validation_result = validate_inputs(design_intent)
    if validation_result.failed:
        raise SystemExit(
            f"Validation failed: {validation_result.validation_errors!r}"
        )

    # 3. Generate AVD facts from the validated design intent
    avd_facts = get_avd_facts(design_intent)

    # 4. Build the structured configuration for a single device
    structured_config = get_device_structured_config(
        hostname="leaf1",
        inputs=design_intent,
        facts=avd_facts,
    )

    # 5. Render the final EOS CLI configuration
    eos_config = get_device_config(structured_config)
    print(eos_config)


if __name__ == "__main__":
    main()

