
# Best Practices

## Open questins...

How to manage MQ configurations on a central system - eg in GIT: See CP Production Deployment Guides for a Gitops approach to MQ and ACE: https://production-gitops.dev/quickstart/quickstart-mq/ 
and https://production-gitops.dev/quickstart/quickstart-ace/

How to set up HA solutions in CP4I (NativeHA, Uniform Cluster, ...)

How to interconnect MQ systems in different clouds / between cloud and existing infrastructure.

Centralized certificate management.


## Good practices related to running in containers

- **Single concern per container**
  - *Steps*
    - Queue manager in one container, application in others
    - Only use client connections, not local bindings
  - *Benefits*
    - Scale independently
    - Patch and update independently
    - Simpler, more intuitive health checking
    - Promotes reuse of container images
    - Easier to retrieve logs, do problem determination
- **Small, decentralized queue managers**
  - *Steps*
    - Queue manager per application instead of shared by multiple applications
    - Right-size QM to meet the individual application workload
  - *Benefits*
    - More agile teams with direct ownership
    - Fine grained resilience to failures or outages
    - Reduce app/QM version compatibility problems
    - Easier to schedule maintenance windows
- **Data availability using external storage**
  - *Steps*
    - Store queue manager data on Persistent Volume outside the container
  - *Benefits*
    - Config / message data survives container restart 
    - Enables failover to other workers in the cluster
    - Simplifies applying upgrades or fixes
    - Supports ephemeral and immutable container approaches
- **Continuous availability through horizontal scaling**
  - *Steps*
    - Deploy two or more equivalent queue managers
    - Distribute workload across the available set using connection routing features such as CCDT, ConnectionNameList or external load balancing
  - *Benefits*
    - Zero downtime for planned upgrades
    - Continue to serve new workload in the event of a failure / failover
    - Scale based on workload requirements
- **Immutable containers**
  - *Steps*
    - Configuration of queue manager is controlled exclusively by a runmqsc script on startup
    - No direct configuration by Administrator
    - Apply config changes by restarting container (coupled with previous two points) 
  - *Benefits*
    - Create a fully configured queue manager from scratch in seconds
    - "Copy" queue manager for horizontal scaling
    - Prevent configuration drift
    - Regular validation of recovery process






























