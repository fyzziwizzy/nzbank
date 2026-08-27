---
name: aws-cost-optimize
description: 'Analyze AWS resources used in the app (IaC files and/or resources in a target account/region) and optimize costs - creating GitHub issues for identified optimizations.'
author: GitHub Copilot (adapted)
version: 1.0.0
created: 2026-08-27
license: MIT
---

# AWS Cost Optimize

This workflow analyzes Infrastructure-as-Code (IaC) files and AWS resources to generate cost optimization recommendations. It creates individual GitHub issues for each optimization opportunity plus one EPIC issue to coordinate implementation, enabling efficient tracking and execution of cost savings initiatives.

## Prerequisites

- AWS CLI configured and authenticated (`aws sts get-caller-identity` succeeds)
- GitHub MCP server configured and authenticated
- Target GitHub repository identified
- AWS resources deployed (IaC files optional but helpful)

## Workflow Steps

### Step 1: Get AWS Cost Optimization Best Practices

**Action**: Retrieve cost optimization best practices before analysis

**Process**:
1. Reference AWS Well-Architected Cost Optimization pillar
2. Identify key optimization patterns:
   - Right-sizing instances based on utilization
   - Reserved Instances and Savings Plans
   - Spot Instances for fault-tolerant workloads
   - Lifecycle policies for data
   - Database optimization patterns
   - Architecture efficiency improvements
3. Use these practices to inform subsequent analysis and recommendations

### Step 2: Discover AWS Infrastructure

**Action**: Dynamically discover and analyze AWS resources and configurations

**Process**:

1. **Account & Region Discovery**:
   - Confirm AWS account identity and authenticated access
   - Determine default region and list all regions in use

2. **Resource Discovery** (per region):
   - EC2 instances: Instance type, state, tags, age
   - RDS instances: Instance class, engine, multi-AZ configuration
   - Lambda functions: Runtime, memory allocation, architecture
   - ECS clusters/services: Container configuration, resource allocation
   - S3 buckets: Storage class, versioning, lifecycle policies
   - ElastiCache clusters: Node type, number of nodes, memory
   - NAT Gateways: Per-zone configuration
   - Load Balancers: Type, availability zones, listeners
   - DynamoDB tables: Billing mode (provisioned vs. on-demand)

3. **IaC Detection**:
   - Scan for Infrastructure-as-Code files: Terraform, CloudFormation, CDK, SAM
   - Parse resource definitions to understand intended configurations
   - **DO NOT** use application code files — only IaC files as source of truth
   - If no IaC files found: STOP and report to user

### Step 3: Collect Usage Metrics & Validate Current Costs

**Action**: Gather utilization data and verify actual resource costs

**Process**:

1. **CloudWatch Metrics** (last 7-30 days):
   - EC2 CPU utilization (average and peak)
   - Memory utilization (where available via agent)
   - Network bandwidth usage
   - Lambda duration and invocation count
   - RDS CPU and database connections
   - Disk space utilization across resources

2. **AWS Cost Explorer Data**:
   - Monthly service-level costs (last 3 months)
   - Service breakdown: Compute, Storage, Database, Network
   - Identify top cost drivers

3. **Calculate Baseline Metrics**:
   - Average CPU/memory utilization per resource
   - Peak utilization periods
   - Daily/weekly patterns
   - Current monthly total cost

### Step 4: Generate Cost Optimization Recommendations

**Action**: Analyze resources to identify optimization opportunities

**Optimization Patterns**:

#### Compute Optimizations
- **EC2 Right-sizing**: Down-size instances running at <20% average CPU
- **Savings Plans**: Convert On-Demand instances to Compute Savings Plans (up to 60% savings)
- **Graviton/ARM Migration**: Migrate to Graviton2/ARM-based instances (30-40% cheaper)
- **Spot Instances**: Use Spot for fault-tolerant and batch workloads (up to 90% discount)
- **Lambda Optimization**: Reduce memory allocation for underutilized functions; use `arm64` architecture (20% cheaper)
- **ECS/EKS Optimization**: Use Fargate Spot for dev/batch; migrate compute-heavy workloads to EC2 Spot

#### Database Optimizations
- **RDS Right-sizing**: Down-size instance class based on utilization metrics
- **Multi-AZ Conversion**: Convert Multi-AZ to Single-AZ for dev/test environments
- **Aurora Serverless**: Migrate variable-load databases to Aurora Serverless v2
- **DynamoDB Optimization**: Switch Provisioned mode → On-Demand for unpredictable traffic
- **ElastiCache Right-sizing**: Down-size node type based on memory utilization

#### Storage Optimizations
- **S3 Lifecycle Policies**: Transition objects (Standard → Standard-IA after 30d → Glacier after 90d)
- **S3 Intelligent-Tiering**: Enable automatic cost optimization for variable access patterns
- **EBS Volume Optimization**: Delete unattached volumes; convert gp2 → gp3 (same performance, 20% cheaper)
- **Snapshot Consolidation**: Identify and delete orphaned snapshots

#### Network Optimizations
- **NAT Gateway Consolidation**: Reduce per-zone NAT Gateways if traffic permits
- **Data Transfer Optimization**: Use VPC endpoints to reduce internet gateway traffic
- **Load Balancer Optimization**: Remove unused load balancers; consolidate where possible

#### Data Transfer & Regional Optimizations
- **Cross-region traffic**: Minimize cross-region data transfer (expensive)
- **CloudFront caching**: Deploy CDN for frequently accessed content
- **Regional consolidation**: Evaluate workload consolidation if multi-region not required

### Step 5: Categorize and Prioritize Recommendations

Organize recommendations by:
- **Estimated Monthly Savings** (sort descending)
- **Effort Level** (Quick win / Medium / Complex)
- **Risk Level** (Low / Medium / High)
- **Category** (Compute, Storage, Database, Network)

### Step 6: Create GitHub Issues

**Action**: Document each recommendation and create coordinated tracking

**Issue Structure**:

For each recommendation, create a GitHub Issue with:
- **Title**: Clear, actionable (e.g., "Right-size prod-db-01 from db.r5.2xlarge to db.r5.xlarge")
- **Description**: 
  - Current state and resource details
  - Recommended change
  - Estimated monthly savings
  - Effort and risk assessment
  - Implementation steps
  - Rollback procedure
- **Labels**: `cost-optimization`, `<category>`, `<effort-level>`, `<risk-level>`
- **Estimates**: Story points or time estimate

**EPIC Issue**:
- Create one "master" EPIC issue titled: "AWS Cost Optimization Initiative - Q[quarter] [Year]"
- Link all individual optimization issues to this EPIC
- Include summary: Total estimated monthly savings, resource count, effort estimate
- Add milestones for phased rollout

### Step 7: Deliver Recommendations

**Action**: Present findings to user

**Deliverables**:
1. Executive summary: Total estimated savings, top 5 opportunities
2. Full list of GitHub issues (with direct links)
3. EPIC issue for project tracking
4. Implementation timeline recommendation

---

## Implementation Guidance

### Before Implementation
- [ ] Review each recommendation's risk assessment
- [ ] Test in dev/staging environment first
- [ ] Verify monitoring and alerting are in place
- [ ] Document current configuration as rollback plan

### Implementation Order
1. Start with "Quick win" items (low effort, high confidence)
2. Progress to "Medium" items with clear success metrics
3. Reserve "Complex" items for planned maintenance windows

### Monitoring Post-Implementation
- CloudWatch dashboards for affected resources
- Cost Explorer trending to validate savings
- Application performance monitoring for regressions
- Reserved Capacity planning based on actual usage

---

## Triggers

Activate this skill when the user asks to:
- "Optimize our AWS costs"
- "Analyze our AWS spending"
- "Find cost savings in AWS"
- "AWS cost review"
- "Reduce AWS bill"
- "Cost optimization analysis"
- "Create AWS cost optimization issues"

---

## Notes & Cautions

⚠️ **Important Safety Practices:**
- Never recommend changes to production without testing
- Verify high-availability requirements before consolidating resources
- Ensure rollback procedures are documented and tested
- Monitor closely for 1-2 weeks after changes
- Coordinate with ops/DevOps team for risky changes
- Document all changes in your infrastructure versioning system
