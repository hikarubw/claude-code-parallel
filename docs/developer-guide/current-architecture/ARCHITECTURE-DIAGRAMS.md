# Architecture Diagrams - Claude Code Parallel v0.3.0

## Overview: Hybrid Pueue+Tmux Architecture

```mermaid
graph TB
    subgraph "User Interface"
        U[User] -->|"/project:work 123,124 8"| CMD[Commands]
    end
    
    subgraph "Intelligence Layer"
        CMD --> A[Claude Analyzer]
        A -->|"Analyzes Issues"| SI[Subissue Creator]
        SI -->|"2-5 subissues per parent"| Q
    end
    
    subgraph "Queue Management - Pueue"
        Q[Priority Queue] -->|"pueue add"| PD[Pueue Daemon]
        PD -->|"Manages tasks"| PT[Pueue Tasks]
        PT -->|"Spawns"| W
    end
    
    subgraph "Worker Pool - Tmux"
        W[Worker Orchestrator] -->|"Creates sessions"| T1[Tmux Session 1]
        W -->|"Creates sessions"| T2[Tmux Session 2]
        W -->|"Creates sessions"| TN[Tmux Session N]
        
        T1 -->|"Runs"| CC1[Claude Code]
        T2 -->|"Runs"| CC2[Claude Code]
        TN -->|"Runs"| CCN[Claude Code]
    end
    
    subgraph "Output"
        CC1 -->|"Creates"| PR1[PR #1]
        CC2 -->|"Creates"| PR2[PR #2]
        CCN -->|"Creates"| PRN[PR #N]
        
        PR1 -->|"Auto-closes"| I1[Issue #123]
        PR2 -->|"Auto-closes"| I1
        PRN -->|"Auto-closes"| I2[Issue #124]
    end
    
    subgraph "Monitoring"
        PD -.->|"Status"| M[Monitoring]
        T1 -.->|"Logs"| M
        T2 -.->|"Logs"| M
        TN -.->|"Logs"| M
        AA[Auto-Approve] -.->|"Watches"| T1
        AA -.->|"Watches"| T2
        AA -.->|"Watches"| TN
    end
```

## Detailed Component Flow

### 1. Issue Analysis and Decomposition

```mermaid
sequenceDiagram
    participant User
    participant CLI
    participant Analyzer
    participant GitHub
    participant Queue
    
    User->>CLI: /project:work 123,124 8
    CLI->>Analyzer: analyze(issues=[123,124])
    
    loop For each issue
        Analyzer->>GitHub: fetch issue details
        GitHub-->>Analyzer: issue content
        Analyzer->>Analyzer: Claude analyzes requirements
        Analyzer->>Analyzer: Create 2-5 subissues
        Analyzer->>GitHub: Create subissues
        GitHub-->>Analyzer: subissue numbers
        Analyzer->>Queue: Add subissues with priority
    end
    
    Queue-->>CLI: Queue populated
    CLI-->>User: Work started
```

### 2. Hybrid Queue and Worker Management

```mermaid
graph LR
    subgraph "Pueue Queue Manager"
        PQ[Priority Queue] -->|"Task 1"| T1[Pueue Task 1]
        PQ -->|"Task 2"| T2[Pueue Task 2]
        PQ -->|"Task N"| TN[Pueue Task N]
        
        T1 -->|"Status: Running"| PS[Pueue Status]
        T2 -->|"Status: Queued"| PS
        TN -->|"Status: Done"| PS
    end
    
    subgraph "Tmux Session Pool"
        T1 ==>|"Spawns"| TS1[worker-1 session]
        T2 ==>|"Will spawn"| TS2[worker-2 session]
        
        TS1 -->|"Executes"| CC1[claude-code instance]
        TS2 -.->|"When ready"| CC2[claude-code instance]
    end
    
    subgraph "Benefits"
        B1[Crash Recovery]
        B2[Persistence]
        B3[Native Retry]
        B4[Resource Control]
        B5[Visibility]
    end
    
    PS --> B1
    PS --> B2
    PS --> B3
    PS --> B4
    TS1 --> B5
```

### 3. Worker Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Queued: Subissue added to Pueue
    
    Queued --> Starting: Pueue schedules task
    Starting --> Running: Tmux session created
    
    Running --> Processing: Claude Code active
    Processing --> Creating_PR: Work completed
    Creating_PR --> Done: PR created
    
    Running --> Failed: Error occurred
    Failed --> Queued: Auto-retry by Pueue
    
    Done --> Cleanup: Task completed
    Cleanup --> [*]: Resources freed
    
    note right of Failed: Pueue handles retries\nautomatically
    note right of Running: Tmux provides\nvisibility
```

### 4. Auto-Approval Integration

```mermaid
graph TB
    subgraph "Auto-Approve Daemon"
        AA[Auto-Approve] -->|"Monitors"| AS[All Sessions]
        AS -->|"Detects prompt"| DP{Approval Needed?}
        DP -->|"Yes"| SA[Send Approval]
        DP -->|"No"| C[Continue Monitoring]
        SA -->|"'y' response"| S[Session]
        C -->|"Loop"| AS
    end
    
    subgraph "Tmux Sessions"
        S1[worker-1] -.->|"Output"| AS
        S2[worker-2] -.->|"Output"| AS
        SN[worker-N] -.->|"Output"| AS
    end
    
    subgraph "Result"
        SA -->|"Enables"| AU[99% Autonomous Operation]
    end
```

### 5. Error Recovery Flow

```mermaid
flowchart TB
    E[Error Occurs] --> T{Error Type}
    
    T -->|"Worker Crash"| WC[Worker Crashed]
    T -->|"Network Issue"| NI[Network Failed]
    T -->|"Git Conflict"| GC[Git Conflict]
    T -->|"Test Failure"| TF[Tests Failed]
    
    WC --> PR[Pueue Detects Failure]
    NI --> PR
    GC --> PR
    TF --> PR
    
    PR --> RT{Retry Logic}
    RT -->|"Retry < 3"| R[Restart Task]
    RT -->|"Retry >= 3"| F[Mark Failed]
    
    R --> NS[New Session]
    NS --> W[Continue Work]
    
    F --> N[Notify User]
    N --> M[Manual Intervention]
```

### 6. Performance Architecture

```mermaid
graph TD
    subgraph "Load Distribution"
        I[100 Subissues] --> PQ[Pueue Queue]
        PQ --> G1[Group: workers-1]
        PQ --> G2[Group: workers-2]
        
        G1 -->|"50 tasks"| W1[8 Workers]
        G2 -->|"50 tasks"| W2[8 Workers]
    end
    
    subgraph "Resource Management"
        W1 --> RM[Resource Monitor]
        W2 --> RM
        RM -->|"CPU < 80%"| SC[Scale Up]
        RM -->|"CPU > 90%"| SD[Scale Down]
        
        SC -->|"pueue parallel N+1"| PQ
        SD -->|"pueue parallel N-1"| PQ
    end
    
    subgraph "Optimization"
        PQ -->|"Priority"| HP[High Priority First]
        PQ -->|"Dependencies"| DO[Dependency Order]
        PQ -->|"Complexity"| CB[Complexity Balancing]
    end
```

## Architecture Evolution

### From v2.0 to v3.0 Hybrid

```mermaid
graph LR
    subgraph "v2.0 Task-Based"
        TB[Checklist Tasks] -->|"Manual"| FQ[File Queue]
        FQ -->|"Fragile"| TMX[Pure Tmux]
        TMX -->|"No persistence"| FAIL1[❌ Data Loss]
    end
    
    subgraph "v3.0 Hybrid"
        SI[Subissues] -->|"Automatic"| PQ[Pueue Queue]
        PQ -->|"Robust"| HYB[Pueue + Tmux]
        HYB -->|"Persistent"| WIN1[✅ Reliable]
    end
    
    TB -.->|"Evolution"| SI
    FQ -.->|"Replaced by"| PQ
    TMX -.->|"Enhanced with"| HYB
```

## Future Architecture: Pueue-TUI

```mermaid
graph TB
    subgraph "Current: Embedded"
        E1[Claude Parallel] -->|"Contains"| Q1[Queue Logic]
        E1 -->|"Contains"| W1[Worker Logic]
        E1 -->|"Contains"| M1[Monitor Logic]
    end
    
    subgraph "Future: Modular"
        PT[Pueue-TUI] -->|"Provides"| QI[Queue Interface]
        PT -->|"Provides"| WM[Worker Management]
        PT -->|"Provides"| UI[Unified UI]
        
        CP[Claude Parallel] -->|"Uses"| PT
        O1[Other Tool 1] -->|"Uses"| PT
        O2[Other Tool 2] -->|"Uses"| PT
    end
    
    E1 ==>|"Extract to"| PT
    
    style PT fill:#90EE90
    style CP fill:#87CEEB
```

## Key Architecture Benefits

1. **Reliability**: Pueue provides industrial-grade queue management
2. **Visibility**: Tmux sessions allow Claude Code to function normally
3. **Persistence**: Queue state survives crashes and reboots
4. **Scalability**: Easy to scale workers up/down with Pueue groups
5. **Simplicity**: Clean separation of concerns between queue and execution
6. **Compatibility**: Works seamlessly with existing Claude Code workflows

## Architecture Decision Records

- [ADR-001](../../archive/proposals/ADR-001-SUBISSUE-WORKER-ARCHITECTURE.md): Subissue-Based Worker Pool
- [ADR-002](../adr/ADR-002-SINGLE-TMUX-VS-PUEUE.md): Analysis of Single Tmux vs Pueue
- [ADR-003](../adr/ADR-003-HYBRID-PUEUE-TMUX.md): Hybrid Pueue+Tmux Architecture
- [ADR-004](../adr/ADR-004-PUEUE-NATIVE-AND-PUEUE-TUI.md): Future Pueue-TUI Extraction