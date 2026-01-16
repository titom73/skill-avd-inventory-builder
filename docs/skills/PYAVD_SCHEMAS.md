# SKILL: PyAVD Network Configuration Builder

**Skill Type**: Network Automation - Configuration Generation  
**Domain**: Arista Networks - Data Center & Campus Networking  
**Complexity**: Advanced  
**Prerequisites**: Python 3.10+, Basic networking knowledge

---

## Skill Overview

This skill enables AI agents to construct valid Arista EOS network configurations using PyAVD's data models and schemas. It provides the knowledge and patterns needed to generate configurations programmatically for data center, campus, and WAN networks.

**What This Skill Teaches:**
- Understanding PyAVD's dual-schema architecture
- Building intent-based network designs (EOS Designs)
- Generating device-specific configurations (EOS CLI Config Gen)
- Validating and converting network data models
- Using 450+ schema fragments for comprehensive network coverage

**Use Cases:**
- Automated network provisioning
- Configuration generation from templates
- Network design validation
- Multi-vendor network translation
- Configuration-as-Code workflows

---

## Quick Start

### Installation

```bash
# Install PyAVD
pip install pyavd

# Or install from source with development dependencies
git clone https://github.com/aristanetworks/avd
cd avd
pip install -e python-avd[dev]
```

### Hello World Example

```python
from pyavd import validate_inputs, get_avd_facts, get_device_structured_config, get_device_config

# 1. Define network intent (high-level design)
design_intent = {
    "fabric_name": "MY_FABRIC",
    "spine": {
        "defaults": {"platform": "vEOS-lab", "bgp_as": "65000"},
        "nodes": [{"name": "spine1", "id": 1, "mgmt_ip": "192.168.0.10/24"}]
    },
    "l3leaf": {
        "defaults": {
            "platform": "vEOS-lab",
            "loopback_ipv4_pool": "10.255.0.0/27",
            "vtep_loopback_ipv4_pool": "10.255.1.0/27"
        },
        "node_groups": [{
            "group": "LEAF1",
            "bgp_as": "65001",
            "nodes": [{"name": "leaf1", "id": 1, "mgmt_ip": "192.168.0.11/24"}]
        }]
    }
}

# 2. Validate design
result = validate_inputs(design_intent)
assert not result.failed, f"Validation failed: {result.validation_errors}"

# 3. Generate facts and structured config
avd_facts = get_avd_facts(design_intent)
structured_config = get_device_structured_config("leaf1", design_intent, avd_facts)

# 4. Generate EOS CLI configuration
eos_config = get_device_config(structured_config)
print(eos_config)
```

---

## Core Concepts

This document provides comprehensive information about PyAVD's schema system and data models, enabling AI agents to construct valid network configurations programmatically.

## Table of Contents

1. [Overview](#overview)
2. [Schema Architecture](#schema-architecture)
3. [Two Main Schemas](#two-main-schemas)
4. [Schema Structure](#schema-structure)
5. [Using Schemas with PyAVD](#using-schemas-with-pyavd)
6. [EOS CLI Config Gen Schema](#eos-cli-config-gen-schema)
7. [EOS Designs Schema](#eos-designs-schema)
8. [Data Model Workflow](#data-model-workflow)
9. [Schema Validation](#schema-validation)
10. [Common Patterns](#common-patterns)
11. [Examples](#examples)

---

## Overview

PyAVD uses a sophisticated schema system to define, validate, and transform network configuration data. The schemas are defined in YAML format and automatically generate Python Pydantic models for runtime validation.

**Key Benefits**:
- **Type safety**: Automatic type conversion and validation
- **Documentation**: Self-documenting data models
- **IDE support**: Auto-completion via generated Python models
- **Consistency**: Enforced structure across all configurations

**Schema Locations**:
- `python-avd/pyavd/_eos_cli_config_gen/schema/schema_fragments/` - 210 schema fragments
- `python-avd/pyavd/_eos_designs/schema/schema_fragments/` - 243 schema fragments

---

## Schema Architecture

### Schema Components

1. **Schema Fragments** (`.schema.yml` files)
   - Individual YAML files defining specific configuration elements
   - Located in `schema_fragments/` directories
   - Combined into complete schemas during build

2. **Generated Python Models** (`schema/__init__.py`)
   - Auto-generated Pydantic models from schema fragments
   - **WARNING**: Never edit these files manually
   - Regenerated during build process

3. **Meta Schema** (`avd_meta_schema.json`)
   - Defines the structure of schema fragments themselves
   - Used for validating schema definitions

4. **Schema Tools** (`AvdSchemaTools`)
   - Python API for working with schemas
   - Provides validation, conversion, and introspection

---

## Two Main Schemas

PyAVD has two primary schemas corresponding to two configuration generation approaches:

### 1. EOS CLI Config Gen Schema

**Purpose**: Low-level, device-specific configuration generation

**Use Case**: When you have a complete structured configuration and need to generate EOS CLI commands

**Schema ID**: `EOS_CLI_CONFIG_GEN_SCHEMA_ID`

**Input**: Structured configuration (dict)
**Output**: EOS CLI configuration (text)

**210 Schema Fragments** covering:
- Interfaces (Ethernet, Loopback, VLAN, Port-Channel, etc.)
- Routing protocols (BGP, OSPF, ISIS, etc.)
- VLANs and VRFs
- AAA, ACLs, QoS
- Management (SSH, API, SNMP, etc.)
- Hardware and platform settings
- And many more...

### 2. EOS Designs Schema

**Purpose**: High-level, intent-based network design

**Use Case**: When you want to define network topology and services at a high level

**Schema ID**: `EOS_DESIGNS_SCHEMA_ID`

**Input**: Design intent (topology, services)
**Output**: Structured configuration (dict)

**243 Schema Fragments** covering:
- Fabric topology (spine-leaf, campus, WAN)
- Node types and roles
- Network services (VLANs, VRFs, routing)
- Connected endpoints
- Design patterns (L3LS, L2LS, MPLS, CV Pathfinder)
- BGP, ISIS, OSPF underlay/overlay settings
- And many more...

---

## Schema Structure

### Schema Fragment Format

Every schema fragment follows this structure:

```yaml
# Copyright header
type: dict  # or list
keys:       # for dict type
  key_name:
    type: str|int|bool|dict|list
    description: "Human-readable description"
    required: true|false
    default: value
    valid_values: [value1, value2, ...]
    min: number  # for int types
    max: number  # for int types
    convert_types:
      - str  # Auto-convert from other types
    # Additional validation rules...
```

### Common Schema Attributes

- **type**: Data type (str, int, bool, dict, list)
- **description**: Documentation string
- **required**: Whether the field is mandatory
- **default**: Default value if not provided
- **valid_values**: Enumeration of allowed values
- **min/max**: Numeric bounds
- **convert_types**: Types to auto-convert from
- **primary_key**: Unique identifier for list items
- **dynamic_keys**: Pattern-based key matching
- **$ref**: Reference to another schema definition

---

## Using Schemas with PyAVD

### Core Functions

PyAVD provides several functions for working with schemas:

```python
from pyavd import (
    validate_inputs,                    # Validate eos_designs inputs
    validate_structured_config,         # Validate eos_cli_config_gen inputs
    get_device_structured_config,       # Generate structured config from design
    get_device_config,                  # Generate CLI config from structured config
    get_avd_facts,                      # Generate AVD facts from inputs
)
```

### Schema Tools API

```python
from pyavd.avd_schema_tools import AvdSchemaTools

# Initialize with a specific schema
schema_tools = AvdSchemaTools(schema_id="eos_designs")

# Convert data according to schema (auto type conversion)
validation_result = schema_tools.convert_data(data)

# Validate data against schema
validation_result = schema_tools.validate_data(data)

# Get documentation for a key path
doc = schema_tools.get_documentation(key_path="fabric_name")
```

---

## EOS CLI Config Gen Schema

This schema defines the **structured configuration** format that AVD uses to generate EOS CLI commands.

### Major Categories (210 fragments)

#### Interfaces
- `ethernet_interfaces` - Physical Ethernet interfaces
- `port_channel_interfaces` - Port-channel (LAG) interfaces
- `loopback_interfaces` - Loopback interfaces
- `vlan_interfaces` - VLAN SVIs
- `tunnel_interfaces` - Tunnel interfaces
- `management_interfaces` - Management interfaces
- `dps_interfaces` - DPS interfaces

#### VLANs and VRFs
- `vlans` - VLAN definitions
- `vrfs` - VRF definitions
- `vxlan_interface` - VXLAN/VTEP configuration

#### Routing Protocols
- `router_bgp` - BGP configuration
- `router_ospf` - OSPF configuration
- `router_isis` - ISIS configuration
- `router_rip` - RIP configuration
- `router_bfd` - BFD configuration
- `static_routes` - Static routes
- `ipv6_static_routes` - IPv6 static routes

#### Access Control
- `access_lists` - Standard ACLs
- `ip_access_lists` - Extended IP ACLs
- `ipv6_access_lists` - IPv6 ACLs
- `mac_access_lists` - MAC ACLs

#### Network Services
- `spanning_tree` - Spanning-tree configuration
- `mlag_configuration` - MLAG/Multi-chassis LAG
- `dhcp_relay` - DHCP relay
- `dhcp_servers` - DHCP server
- `ip_dhcp_snooping` - DHCP snooping

#### Management
- `aaa_authentication` - AAA authentication
- `aaa_authorization` - AAA authorization
- `aaa_accounting` - AAA accounting
- `local_users` - Local user accounts
- `management_api_http` - eAPI configuration
- `management_api_gnmi` - gNMI configuration
- `management_ssh` - SSH configuration
- `snmp_server` - SNMP configuration
- `logging` - Logging configuration

#### QoS and Traffic
- `qos` - Quality of Service
- `qos_profiles` - QoS profiles
- `policy_maps` - Policy maps
- `class_maps` - Class maps
- `traffic_policies` - Traffic policies

### Example: VLANs Schema

```yaml
vlans:
  type: list
  primary_key: id
  items:
    type: dict
    keys:
      id:
        type: int
        description: VLAN ID
      name:
        type: str
        description: VLAN Name
      state:
        type: str
        valid_values: ["active", "suspend"]
      trunk_groups:
        type: list
        items:
          type: str
```

### Example: Ethernet Interfaces Schema

```yaml
ethernet_interfaces:
  type: list
  primary_key: name
  items:
    type: dict
    keys:
      name:
        type: str
      description:
        type: str
      shutdown:
        type: bool
      mtu:
        type: int
        min: 68
        max: 65535
      speed:
        type: str
        valid_values: ["auto", "10g", "25g", "40g", "100g", ...]
      # Many more keys...
```

### Example: Router BGP Schema

```yaml
router_bgp:
  type: dict
  keys:
    as:
      type: str
      description: BGP AS number
    router_id:
      type: str
      description: Router ID in IP format
    bgp_defaults:
      type: list
      items:
        type: str
    peer_groups:
      type: list
      primary_key: name
      items:
        type: dict
        keys:
          name:
            type: str
          # Peer group configuration...
    # Many more keys...
```

---

## EOS Designs Schema

This schema defines the **design intent** that AVD uses to generate structured configurations.

### Major Categories (243 fragments)

#### Fabric Topology
- `fabric_name` - Fabric identifier (required)
- `design` - Network design pattern (deprecated in 6.0)
- `type` - Device type (spine, leaf, border, etc.)
- `node_type_keys` - Define custom node types
- `default_node_types` - Default node type definitions

#### Node Configuration
- `devices` - Device-specific settings
- `device_profiles` - Reusable device profiles
- `l3_edge` - L3 edge connections
- `core_interfaces` - Core/uplink interfaces
- `connected_endpoints` - Endpoint connections (servers, firewalls, etc.)

#### Network Services
- `network_services` - VLAN/VRF services
- `network_services_keys` - Custom service definitions
- `l2vlan_profiles` - L2 VLAN profiles
- `svi_profiles` - SVI (VLAN interface) profiles
- `port_profiles` - Reusable port configurations

#### BGP Configuration
- `bgp_as` - BGP AS number
- `bgp_peer_groups` - BGP peer group templates
- `bgp_mesh_pes` - PE mesh configuration
- `evpn_*` - EVPN-specific settings

#### Underlay/Overlay
- `underlay_routing_protocol` - Underlay protocol (BGP, OSPF, ISIS)
- `overlay_routing_protocol` - Overlay protocol (eBGP, iBGP)
- `underlay_ipv6` - IPv6 underlay support
- `isis_*` - ISIS-specific settings
- `ospf_*` - OSPF-specific settings

#### CV Pathfinder (SD-WAN)
- `wan_mode` - WAN mode configuration
- `wan_carriers` - WAN carrier definitions
- `wan_path_groups` - Path group definitions
- `cv_pathfinder_regions` - Region definitions
- `wan_virtual_topologies` - Virtual topology policies

#### IP Addressing
- `fabric_ip_addressing` - IP addressing schemes
- `mgmt_gateway` - Management gateway
- `mgmt_interface` - Management interface settings

#### Platform Settings
- `platform_settings` - Platform-specific configs
- `platform_speed_groups` - Interface speed groups

### Example: Fabric Name (Required)

```yaml
fabric_name:
  type: str
  required: true
  description: Fabric Name, must match Ansible group name
```

### Example: Device Type

```yaml
type:
  type: str
  description: Device type (spine, leaf, border, etc.)
  # Valid values determined by node_type_keys
```

### Example: Network Services

```yaml
network_services:
  type: list
  primary_key: name
  items:
    type: dict
    keys:
      name:
        type: str
        description: VRF name
      vrfs:
        type: list
        items:
          type: dict
          keys:
            name:
              type: str
            vlans:
              type: list
              items:
                type: dict
                keys:
                  id:
                    type: int
                  name:
                    type: str
                  # VLAN configuration...
```

### Example: Connected Endpoints

```yaml
connected_endpoints:
  type: list
  primary_key: name
  items:
    type: dict
    keys:
      name:
        type: str
        description: Endpoint name
      adapters:
        type: list
        items:
          type: dict
          keys:
            endpoint_ports:
              type: list
            switch_ports:
              type: list
            switches:
              type: list
```

---

## Data Model Workflow

### Complete Configuration Generation Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    1. Design Intent                          │
│                   (EOS Designs Input)                        │
│  - fabric_name: "DC1"                                        │
│  - devices: [spine1, leaf1, ...]                            │
│  - network_services: [tenant1, ...]                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
         ┌─────────────────────────┐
         │  validate_inputs()      │
         │  (Schema validation)    │
         └────────────┬────────────┘
                      │
                      ▼
         ┌─────────────────────────┐
         │  get_avd_facts()        │
         │  (Topology facts)       │
         └────────────┬────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│            2. Structured Configuration                       │
│           (EOS CLI Config Gen Input)                        │
│  - vlans: [...]                                             │
│  - ethernet_interfaces: [...]                               │
│  - router_bgp: {...}                                        │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
         ┌─────────────────────────────┐
         │  validate_structured_config()│
         │  (Schema validation)         │
         └────────────┬────────────────┘
                      │
                      ▼
         ┌─────────────────────────┐
         │  get_device_config()    │
         │  (Jinja2 templating)    │
         └────────────┬────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    3. EOS CLI Config                         │
│  vlan 10                                                     │
│    name VLAN10                                              │
│  interface Ethernet1                                         │
│    description Link to spine1                               │
└─────────────────────────────────────────────────────────────┘
```

### Workflow Steps

1. **Define Design Intent** (EOS Designs Schema)
   - High-level topology and services
   - Validated with `validate_inputs()`

2. **Generate Structured Config** (EOS CLI Config Gen Schema)
   - AVD transforms design intent to structured config
   - Using `get_device_structured_config()`

3. **Generate CLI Configuration**
   - Jinja2 templates convert structured config to CLI
   - Using `get_device_config()`

---

## Schema Validation

### Validation Features

PyAVD schemas provide comprehensive validation:

- **Type validation**: Ensures correct data types
- **Type conversion**: Automatically converts compatible types
- **Range validation**: min/max bounds for numeric values
- **Enum validation**: valid_values restrictions
- **Required fields**: Enforces mandatory fields
- **Deprecation warnings**: Alerts on deprecated keys
- **Cross-field validation**: Validates relationships between fields

### Validation Example

```python
from pyavd import validate_inputs, ValidationResult

# Input data (might have type mismatches)
inputs = {
    "fabric_name": "DC1",
    "bgp_as": 65001,  # Will be converted to string "65001"
    "devices": [
        {
            "name": "leaf1",
            "id": "1",  # Will be converted to int 1
            "type": "leaf",
        }
    ]
}

# Validate and convert
result: ValidationResult = validate_inputs(inputs)

# Check results
if result.failed:
    print("Validation failed:")
    for error in result.validation_errors:
        print(f"  - {error}")
else:
    print("Validation passed!")
    if result.deprecation_warnings:
        print("Deprecation warnings:")
        for warning in result.deprecation_warnings:
            print(f"  - {warning}")
```

### ValidationResult Object

```python
class ValidationResult:
    failed: bool                          # True if validation failed
    validation_errors: list[Exception]    # List of validation errors
    deprecation_warnings: list[Warning]   # List of deprecation warnings
    
    def merge(self, other: ValidationResult) -> None:
        """Merge another validation result"""
```

---

## Common Patterns

### Pattern 1: List with Primary Key

Most configuration lists use a primary key for identification:

```yaml
vlans:
  type: list
  primary_key: id  # Unique identifier
  items:
    type: dict
    keys:
      id:
        type: int
      name:
        type: str
```

**Usage**:
```python
vlans = [
    {"id": 10, "name": "VLAN10"},
    {"id": 20, "name": "VLAN20"},
]
```

### Pattern 2: Type Conversion

Schemas can auto-convert between compatible types:

```yaml
bgp_as:
  type: str
  convert_types:
    - int  # Auto-convert int to str
```

**Usage**:
```python
# Both valid - int auto-converted to str
bgp_as = 65001      # Converted to "65001"
bgp_as = "65001"    # Already string
```

### Pattern 3: Valid Values (Enums)

Restrict values to predefined options:

```yaml
state:
  type: str
  valid_values: ["active", "suspend"]
```

### Pattern 4: Nested Dictionaries

Complex configurations use nested dicts:

```yaml
router_bgp:
  type: dict
  keys:
    as:
      type: str
    peer_groups:
      type: list
      items:
        type: dict
        keys:
          name:
            type: str
```

### Pattern 5: Dynamic Keys

Allow arbitrary key names with specific value types:

```yaml
network_services:
  type: dict
  dynamic_keys:
    type: dict
    # Keys can be any string
```

### Pattern 6: Schema References

Reuse definitions with `$ref`:

```yaml
l3_edge:
  type: dict
  $ref: "eos_designs#/$defs/l3_edge"
```

---

## Examples

### Example 1: Basic L3LS Fabric (EOS Designs)

```python
from pyavd import validate_inputs, get_avd_facts, get_device_structured_config

# Design intent
inputs = {
    "fabric_name": "DC1",
    "design": {
        "type": "l3ls-evpn"
    },
    "bgp_as": "65001",
    "spine": {
        "defaults": {
            "platform": "vEOS-lab",
            "bgp_as": "65001",
        },
        "nodes": [
            {
                "name": "dc1-spine1",
                "id": 1,
                "mgmt_ip": "192.168.0.10/24",
            }
        ]
    },
    "l3leaf": {
        "defaults": {
            "platform": "vEOS-lab",
            "spanning_tree_mode": "mstp",
            "spanning_tree_priority": 4096,
            "loopback_ipv4_pool": "10.255.0.0/27",
            "vtep_loopback_ipv4_pool": "10.255.1.0/27",
        },
        "node_groups": [
            {
                "group": "DC1_L3_LEAF1",
                "bgp_as": "65101",
                "nodes": [
                    {
                        "name": "dc1-leaf1a",
                        "id": 1,
                        "mgmt_ip": "192.168.0.11/24",
                        "uplink_switch_interfaces": ["Ethernet1"],
                    }
                ]
            }
        ]
    }
}

# Step 1: Validate design inputs
validation_result = validate_inputs(inputs)
assert not validation_result.failed

# Step 2: Generate AVD facts
avd_facts = get_avd_facts(inputs)

# Step 3: Generate structured config for device
structured_config = get_device_structured_config(
    hostname="dc1-leaf1a",
    inputs=inputs,
    avd_facts=avd_facts
)

print(structured_config)
# Output includes: vlans, ethernet_interfaces, router_bgp, etc.
```

### Example 2: Structured Config to CLI (EOS CLI Config Gen)

```python
from pyavd import validate_structured_config, get_device_config

# Structured configuration (could be from get_device_structured_config)
structured_config = {
    "vlans": [
        {"id": 10, "name": "VLAN10"},
        {"id": 20, "name": "VLAN20"},
    ],
    "ethernet_interfaces": [
        {
            "name": "Ethernet1",
            "description": "Link to spine1",
            "shutdown": False,
            "mtu": 9214,
            "type": "routed",
            "ip_address": "10.0.0.1/31",
        }
    ],
    "router_bgp": {
        "as": "65101",
        "router_id": "10.255.0.1",
        "bgp_defaults": ["no bgp default ipv4-unicast"],
        "peer_groups": [
            {
                "name": "UNDERLAY",
                "type": "ipv4",
                "maximum_routes": 12000,
                "send_community": "all",
            }
        ],
    }
}

# Step 1: Validate structured config
validation_result = validate_structured_config(structured_config)
assert not validation_result.failed

# Step 2: Generate CLI configuration
cli_config = get_device_config(structured_config)

print(cli_config)
# Output:
# !
# vlan 10
#    name VLAN10
# !
# vlan 20
#    name VLAN20
# !
# interface Ethernet1
#    description Link to spine1
#    no shutdown
#    mtu 9214
#    no switchport
#    ip address 10.0.0.1/31
# !
# router bgp 65101
#    router-id 10.255.0.1
#    no bgp default ipv4-unicast
#    neighbor UNDERLAY peer group
#    neighbor UNDERLAY send-community
#    neighbor UNDERLAY maximum-routes 12000
# !
```

### Example 3: Network Services (VLANs/VRFs)

```python
# EOS Designs input for network services
network_services = [
    {
        "name": "TENANT1",
        "vrfs": [
            {
                "name": "VRF1",
                "svis": [
                    {
                        "id": 10,
                        "name": "VLAN10",
                        "enabled": True,
                        "ip_address_virtual": "10.10.10.1/24",
                    }
                ]
            }
        ]
    }
]

inputs = {
    "fabric_name": "DC1",
    "network_services": network_services,
    # ... other design parameters
}
```

### Example 4: Connected Endpoints

```python
# EOS Designs input for server connections
connected_endpoints = [
    {
        "name": "server01",
        "adapters": [
            {
                "endpoint_ports": ["eth0", "eth1"],
                "switch_ports": ["Ethernet10", "Ethernet10"],
                "switches": ["dc1-leaf1a", "dc1-leaf1b"],
                "profile": "TENANT1_10G",
                "port_channel": {
                    "description": "server01_PortChannel",
                    "mode": "active",
                },
                "vlans": "10,20",
            }
        ]
    }
]

inputs = {
    "fabric_name": "DC1",
    "connected_endpoints": connected_endpoints,
    # ... other design parameters
}
```

### Example 5: Programmatic Schema Exploration

```python
from pyavd.avd_schema_tools import AvdSchemaTools

# Load schema
schema_tools = AvdSchemaTools(schema_id="eos_designs")

# Get schema for specific key
fabric_name_schema = schema_tools.avdschema.get_schema("fabric_name")
print(fabric_name_schema)
# {'type': 'str', 'required': True, 'description': 'Fabric Name...'}

# Get all top-level keys
root_schema = schema_tools.avdschema.get_schema()
print(root_schema.keys())
# dict_keys(['fabric_name', 'design', 'type', 'devices', ...])
```

---

## Skill Application Guide

### When to Use This Skill

**✅ Ideal For:**
- Generating configurations for Arista EOS devices
- Building data center fabrics (L3LS, L2LS, VXLAN-EVPN)
- Campus network automation
- SD-WAN (CV Pathfinder) deployments
- Configuration migration and standardization
- Network-as-Code implementations

**❌ Not Suitable For:**
- Non-Arista network devices (Cisco, Juniper, etc.)
- Real-time network orchestration (use separate orchestration tools)
- Network monitoring (use ANTA or other monitoring tools)
- Configuration deployment (use Ansible or CVP)

### Integration Patterns

#### Pattern 1: Standalone Configuration Generator

```python
from pyavd import validate_inputs, get_avd_facts, get_device_structured_config

def generate_network_configs(topology_data: dict) -> dict[str, dict]:
    """Generate configs for all devices in topology."""
    # Validate
    result = validate_inputs(topology_data)
    if result.failed:
        raise ValueError(f"Invalid topology: {result.validation_errors}")
    
    # Generate facts
    avd_facts = get_avd_facts(topology_data)
    
    # Generate config for each device
    configs = {}
    for hostname in avd_facts.keys():
        configs[hostname] = get_device_structured_config(
            hostname, topology_data, avd_facts
        )
    
    return configs
```

#### Pattern 2: API Service Integration

```python
from fastapi import FastAPI, HTTPException
from pyavd import validate_inputs, get_avd_facts, get_device_structured_config

app = FastAPI()

@app.post("/api/v1/generate-config")
async def generate_config(design: dict):
    """API endpoint to generate network configurations."""
    try:
        # Validate input
        result = validate_inputs(design)
        if result.failed:
            raise HTTPException(400, detail=str(result.validation_errors))
        
        # Generate configs
        avd_facts = get_avd_facts(design)
        configs = {
            hostname: get_device_structured_config(hostname, design, avd_facts)
            for hostname in avd_facts.keys()
        }
        
        return {"status": "success", "configs": configs}
    except Exception as e:
        raise HTTPException(500, detail=str(e))
```

#### Pattern 3: GitOps Workflow Integration

```python
from pyavd import validate_inputs, get_avd_facts, get_device_config
import git
import yaml

def gitops_config_generator(repo_path: str, design_file: str):
    """Generate and commit configs in GitOps workflow."""
    # Load design from YAML
    with open(f"{repo_path}/{design_file}") as f:
        design = yaml.safe_load(f)
    
    # Validate
    result = validate_inputs(design)
    if result.failed:
        raise ValueError("Design validation failed")
    
    # Generate configs
    avd_facts = get_avd_facts(design)
    
    for hostname in avd_facts.keys():
        structured = get_device_structured_config(hostname, design, avd_facts)
        cli_config = get_device_config(structured)
        
        # Write to repo
        with open(f"{repo_path}/configs/{hostname}.cfg", "w") as f:
            f.write(cli_config)
    
    # Git commit
    repo = git.Repo(repo_path)
    repo.index.add(["configs/"])
    repo.index.commit("Auto-generated configs from design")
```

### Best Practices for AI Agents

#### 1. Always Validate Input Data

```python
from pyavd import validate_inputs

result = validate_inputs(design_data)
if result.failed:
    # Handle errors before proceeding
    raise Exception(f"Validation failed: {result.validation_errors}")
```

#### 2. Use Type Conversion

Let the schema handle type conversions instead of manual casting:

```python
# Good - let schema convert
inputs = {"bgp_as": 65001}  # int will be converted to "65001"

# Unnecessary manual conversion
inputs = {"bgp_as": str(65001)}
```

#### 3. Follow Schema Structure

Always check schema structure before constructing data:

```python
# VLANs is a list with primary_key "id"
vlans = [
    {"id": 10, "name": "VLAN10"},  # Correct
    # {"vlan_id": 10, "name": "VLAN10"},  # Wrong key name
]
```

#### 4. Handle Deprecations

Check for deprecation warnings and update code:

```python
result = validate_inputs(inputs)
for warning in result.deprecation_warnings:
    logger.warning(f"Deprecated: {warning}")
    # Take action to update to new format
```

#### 5. Leverage Schema Documentation

Use schema metadata for self-documenting code:

```python
schema_tools = AvdSchemaTools(schema_id="eos_designs")
help_text = schema_tools.avdschema.get_schema("fabric_name")
print(help_text.get("description"))
```

#### 6. Build Incrementally

Start with required fields, then add optional ones:

```python
# Start with minimum required
minimal_input = {
    "fabric_name": "DC1",  # Required
}

# Add optional configurations
full_input = {
    "fabric_name": "DC1",
    "bgp_as": "65001",      # Optional
    "spine": {...},          # Optional
}
```

#### 7. Use Examples as Templates

Study existing examples in the AVD repository for patterns:
- `single-dc-l3ls/` - Single data center L3 leaf-spine
- `dual-dc-l3ls/` - Multi-DC with DCI
- `campus-fabric/` - Campus network design
- `cv-pathfinder/` - SD-WAN with CV Pathfinder

---

## Skill Mastery Checklist

### Level 1: Beginner
- [ ] Install PyAVD successfully
- [ ] Run the Hello World example
- [ ] Understand the difference between EOS Designs and EOS CLI Config Gen
- [ ] Create a simple VLAN configuration
- [ ] Validate input data using `validate_inputs()`
- [ ] Generate structured config for a single device

### Level 2: Intermediate
- [ ] Build a complete L3LS fabric with spines and leafs
- [ ] Configure network services (VLANs, VRFs)
- [ ] Add connected endpoints (servers)
- [ ] Handle validation errors and deprecation warnings
- [ ] Use type conversion features
- [ ] Generate CLI configurations from structured configs

### Level 3: Advanced
- [ ] Design multi-DC fabrics with DCI
- [ ] Implement CV Pathfinder (SD-WAN) topologies
- [ ] Create custom node types
- [ ] Use device and SVI profiles
- [ ] Integrate with APIs or GitOps workflows
- [ ] Handle complex BGP configurations (route servers, RR)

### Level 4: Expert
- [ ] Build campus fabric designs
- [ ] Implement EVPN multicast configurations
- [ ] Create custom validation logic
- [ ] Optimize schema usage for performance
- [ ] Contribute to AVD schema development
- [ ] Design reusable configuration libraries

---

## Troubleshooting Guide

### Common Issues and Solutions

#### Issue 1: Validation Failures

**Problem**: `ValidationResult.failed = True`

**Solutions**:
```python
# Check specific errors
result = validate_inputs(data)
if result.failed:
    for error in result.validation_errors:
        print(f"Error: {error}")
        # Common causes:
        # - Missing required field (e.g., fabric_name)
        # - Invalid type (e.g., string instead of int)
        # - Invalid enum value
        # - Out of range value
```

#### Issue 2: Type Conversion Issues

**Problem**: Type mismatch errors

**Solution**:
```python
# Check schema for convert_types support
from pyavd.avd_schema_tools import AvdSchemaTools

schema_tools = AvdSchemaTools(schema_id="eos_designs")
schema = schema_tools.avdschema.get_schema("bgp_as")
print(schema.get("convert_types"))  # Check if conversion supported
```

#### Issue 3: Missing Configuration Elements

**Problem**: Generated config lacks expected elements

**Solution**:
```python
# Ensure all parent structures are defined
structured_config = {
    "router_bgp": {
        "as": "65001",  # Required parent
        "peer_groups": [  # Now this will work
            {"name": "UNDERLAY", "type": "ipv4"}
        ]
    }
}
```

#### Issue 4: Schema Not Found

**Problem**: `SchemaNotFoundError`

**Solution**:
```python
# Use correct schema_id
from pyavd.constants import EOS_DESIGNS_SCHEMA_ID, EOS_CLI_CONFIG_GEN_SCHEMA_ID

# For design validation
schema_tools = AvdSchemaTools(schema_id=EOS_DESIGNS_SCHEMA_ID)

# For structured config validation
schema_tools = AvdSchemaTools(schema_id=EOS_CLI_CONFIG_GEN_SCHEMA_ID)
```

---

## Advanced Techniques

### Technique 1: Dynamic Config Generation

```python
def generate_leaf_configs(leaf_count: int, base_id: int = 1):
    """Dynamically generate leaf configurations."""
    leaf_nodes = []
    for i in range(leaf_count):
        leaf_id = base_id + i
        leaf_nodes.append({
            "name": f"leaf{leaf_id}",
            "id": leaf_id,
            "mgmt_ip": f"192.168.0.{10 + leaf_id}/24",
            "uplink_switch_interfaces": [f"Ethernet{i+1}" for i in range(2)]
        })
    return leaf_nodes
```

### Technique 2: Configuration Templates

```python
def create_tenant_vrf(tenant_name: str, vrf_name: str, vlan_ids: list[int]):
    """Template for creating tenant VRF configurations."""
    return {
        "name": tenant_name,
        "vrfs": [{
            "name": vrf_name,
            "svis": [
                {
                    "id": vlan_id,
                    "name": f"VLAN{vlan_id}",
                    "enabled": True,
                    "ip_address_virtual": f"10.{vlan_id}.0.1/24"
                }
                for vlan_id in vlan_ids
            ]
        }]
    }

# Usage
tenant = create_tenant_vrf("CUSTOMER_A", "VRF_A", [10, 20, 30])
```

### Technique 3: Bulk Validation

```python
def validate_multiple_designs(designs: dict[str, dict]) -> dict[str, ValidationResult]:
    """Validate multiple network designs."""
    results = {}
    for name, design in designs.items():
        result = validate_inputs(design)
        results[name] = result
        if result.failed:
            print(f"Design '{name}' failed validation")
    return results
```

### Technique 4: Schema-Driven UI Generation

```python
def generate_form_fields(schema_id: str, key_path: str = None):
    """Generate UI form fields from schema."""
    from pyavd.avd_schema_tools import AvdSchemaTools
    
    schema_tools = AvdSchemaTools(schema_id=schema_id)
    schema = schema_tools.avdschema.get_schema(key_path)
    
    fields = []
    for key, value in schema.get("keys", {}).items():
        field = {
            "name": key,
            "type": value.get("type"),
            "required": value.get("required", False),
            "description": value.get("description", ""),
            "valid_values": value.get("valid_values", [])
        }
        fields.append(field)
    
    return fields
```

---

## Reference Documentation

### Official Resources
- **Online Schema Documentation**: https://avd.arista.com/stable/roles/eos_cli_config_gen/index.html
- **PyAVD API Documentation**: https://avd.arista.com/stable/docs/pyavd/pyavd.html
- **GitHub Repository**: https://github.com/aristanetworks/avd
- **Community Support**: https://github.com/aristanetworks/avd/discussions

### Schema Locations (in AVD repository)
- **EOS CLI Config Gen Schemas**: `python-avd/pyavd/_eos_cli_config_gen/schema/schema_fragments/`
- **EOS Designs Schemas**: `python-avd/pyavd/_eos_designs/schema/schema_fragments/`
- **Examples**: `ansible_collections/arista/avd/examples/`

### Related Skills
- **ANTA**: Arista Network Test Automation (testing generated configs)
- **Ansible**: Deployment and orchestration
- **CloudVision Portal**: Centralized management
- **Git**: Version control for network-as-code

---

## Skill Summary

### What You Learned

This skill provides comprehensive knowledge of PyAVD's schema system:

1. **Two-level abstraction**:
   - **EOS Designs**: High-level network intent
   - **EOS CLI Config Gen**: Low-level device configuration

2. **450+ schema fragments** covering:
   - All EOS configuration elements
   - Multiple network design patterns
   - Comprehensive validation rules

3. **Programmatic API** for:
   - Configuration generation
   - Data validation
   - Schema introspection
   - Type conversion

4. **Integration patterns** for:
   - Standalone tools
   - API services
   - GitOps workflows
   - CI/CD pipelines

### Key Takeaways

✅ PyAVD enables infrastructure-as-code for Arista networks  
✅ Schema-driven validation ensures configuration correctness  
✅ Two-level abstraction separates intent from implementation  
✅ Type conversion and validation reduce human errors  
✅ Extensible for custom use cases and integrations

### Next Steps

1. **Practice**: Start with simple examples and gradually increase complexity
2. **Explore**: Study schema fragments to understand available options
3. **Integrate**: Incorporate PyAVD into your automation workflows
4. **Contribute**: Share patterns and improvements with the AVD community
5. **Stay Updated**: Follow AVD releases for new features and schemas

---

## License and Attribution

**PyAVD** is developed and maintained by Arista Networks, Inc.

- **License**: Apache 2.0
- **Copyright**: 2023-2026 Arista Networks, Inc.
- **Repository**: https://github.com/aristanetworks/avd

This skill document is designed for educational purposes and to facilitate the use of PyAVD in other projects and repositories.
