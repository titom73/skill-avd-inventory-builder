# Generate AVD Data - Skills Index

This plugin provides AI skills for generating Arista AVD (Arista Validated Designs) network configurations using PyAVD.

## Available Skills

### 1. PyAVD Network Configuration Builder (`generate_avd_data`)

**Primary Skill**: [generate_avd_data.md](generate_avd_data.md)

**Description**: Generate valid Arista EOS network configurations using PyAVD's data models and schemas. This skill enables AI agents to construct configurations for data center, campus, and WAN networks.

**Key Capabilities**:
- Understanding PyAVD's dual-schema architecture
- Building intent-based network designs (EOS Designs)
- Generating device-specific configurations (EOS CLI Config Gen)
- Validating and converting network data models
- Using 450+ schema fragments for comprehensive network coverage

**Use Cases**:
- Automated network provisioning
- Configuration generation from templates
- Network design validation
- Multi-vendor network translation
- Configuration-as-Code workflows

**Prerequisites**:
- Python 3.10+
- PyAVD 5.0.0+
- Basic networking knowledge

## Examples

All examples are located in the `docs/examples/` directory:

1. **eos_designs_minimal_fabric.yml**: Minimal fabric example for eos_designs
2. **pyavd_hello_world.py**: Sample Python script demonstrating the complete PyAVD workflow

## Getting Started

After installation via `claude plugin install`, the skills are automatically available in your Claude environment. Reference them in your prompts:

```
Using the generate_avd_data skill, create a 2-spine / 4-leaf fabric design for a data center.
```

## Documentation

For detailed installation and usage instructions, see:
- [README.md](../../README.md)
- [INSTALL.md](../../INSTALL.md)

## Support

For issues and questions, please refer to the repository or contact the maintainer.
