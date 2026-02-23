# FC'26 Paper NFT Artwork — Artist Brief

## Project
Each of the 47 papers accepted to FC'26 (Financial Cryptography 2026) gets a unique piece of artwork used as an NFT image. Authors can claim their paper's NFT by verifying their email.

## Deliverable
- **Format**: PNG, 1024×1024px (square)
- **Background**: Dark (#0a0a1a or similar deep navy/black)
- **Text overlay**: We add the paper title ourselves as a text overlay on the bottom — **do NOT include any text in the artwork**
- **Bottom 20%**: Keep relatively dark/empty to accommodate the title overlay

## Style Guidelines
- Clean, modern, geometric/abstract
- Think: data visualization art, constellation maps, circuit diagrams, architectural blueprints
- Vivid accent colors on dark backgrounds (cyan, magenta, gold work well but not required)
- Each image should feel distinct but part of a cohesive collection
- Avoid photorealism — prefer stylized/vector/diagrammatic aesthetics
- Reference the paper's core concept, not just generic "crypto" imagery

---

## Papers

### Paper #5 — Transfer algorithm for on-chain one-hop routing
**Session**: DeFi & AMMs
**Concept**: A routing algorithm for optimal token swapping in one hop. Think: two tokens connected by an optimal path through a network of liquidity pools. Arrows showing flow between nodes.
**Abstract**: We propose a routing algorithm that finds the optimal onehop swapping between two tokens. The gas consumption is optimized so that it can be run fully on-chain and supports large query amount.

---

### Paper #13 — Majorum: Ebb-and-Flow Consensus with Dynamic Quorums
**Session**: Consensus — Fast Finality
**Concept**: Consensus protocol where participants go online/offline like tides. Visualize: nodes appearing and disappearing in waves, with a stable core maintaining agreement. Ebb and flow motion.
**Abstract**: Dynamic availability refers to a consensus protocol's ability to tolerate participants going offline and later rejoining without sacrificing liveness. We present Majorum, the first ebb-and-flow construction built on a quorum-based dynamically-available protocol, finalizing blocks in as few as three slots.

---

### Paper #14 — Incentive-Compatible Recovery from Manipulated Signals
**Session**: Incentives & Decentralization
**Concept**: Signal manipulation and recovery. A source emitting signals, observers interpreting them, some signals being distorted/manipulated. DePIN sensors feeding data. Truth emerging from noise.
**Abstract**: We introduce the first formal model capturing the elicitation of unverifiable information from a party (the "source") with implicit signals derived by other players (the "observers"). Motivated by decentralized physical infrastructure networks (DePIN).

---

### Paper #17 — Incentivizing Geographic Diversity for Decentralized Systems
**Session**: Incentives & Decentralization
**Concept**: A world map or globe with nodes distributed across different regions, with incentive mechanisms pulling nodes apart to spread geographically. Clustering vs dispersion tension.
**Abstract**: We study how to incentivize geographic diversity in decentralized systems, where having nodes concentrated in few locations creates systemic risk.

---

### Paper #26 — Chain-in-the-Box: Large-scale Blockchain Prototyping on a Single Machine
**Session**: Consensus & Smart Contracts
**Concept**: A blockchain system contained inside a box/cube. Multiple chains, nodes, and network topology all compressed into one container. Miniaturization of a large system.
**Abstract**: We present Chain-in-the-Box (CBox), an emulation-based prototyping and evaluation framework for blockchain systems that modularizes using a staged event-driven model.

---

### Paper #30 — On Cryptographic Cheap Talk with Smart Contracts
**Session**: Consensus & Smart Contracts
**Concept**: Game theory meets cryptography. Two players communicating through a smart contract that acts as a correlation device. Speech bubbles, strategic interaction, a mediating contract in between.
**Abstract**: We revisit cryptographic cheap talk — pre-play protocols for implementing correlated strategies in strategic games — in a new setting where players interact with smart contracts as correlation devices.

---

### Paper #37 — On the (Un)biasability of Existing Verifiable Random Functions
**Session**: PoS & Block Production
**Concept**: A random number generator being tested for bias. Dice, coins, or abstract randomness sources with some being tilted/biased and others perfectly balanced. Verification checkmarks.
**Abstract**: We study the biasability of existing Verifiable Random Functions (VRFs) and show attacks or prove security bounds.

---

### Paper #41 — Secure MSM Outsourcing Computation for Zero-knowledge Proof Generation
**Session**: Zero-Knowledge Proofs
**Concept**: Multi-scalar multiplication (many points on an elliptic curve being combined). Computation being delegated from a small device to a powerful server, with a verification shield ensuring correctness.
**Abstract**: We present secure outsourcing protocols for multi-scalar multiplication, the computational bottleneck in zero-knowledge proof generation, allowing untrusted servers to assist.

---

### Paper #55 — Oops!... I Did It Again. I Reused my Nonce.
**Session**: Nonce and Key Reuse
**Concept**: A cryptographic nonce being reused — same random number appearing twice in different signatures, with a crack/fracture revealing the private key underneath. Danger/warning aesthetic.
**Abstract**: Large-scale analysis of ECDSA signatures across blockchains, identifying cases of nonce reuse that allow attackers to recover private keys and steal funds.

---

### Paper #58 — Collusion-Safe Proxy Re-Encryption
**Session**: Threshold & Encryption
**Concept**: Encrypted messages being re-encrypted through a proxy, but with shields preventing the proxy from colluding with recipients. Three entities: sender, proxy, receiver with trust barriers.
**Abstract**: Proxy re-encryption where a proxy can transform ciphertexts from one key to another, designed to prevent collusion between the proxy and delegatees.

---

### Paper #86 — Making the Memorable Unguessable
**Session**: Privacy & Trust
**Concept**: A password/passphrase that is both memorable (brain, lightbulb) and secure (lock, shield). The tension between human memory and cryptographic strength. Memorable patterns that resist guessing.
**Abstract**: We treat personally identifiable information as a controlled security primitive for generating passwords and honeywords that are memorable yet resist guessing attacks.

---

### Paper #88 — Plaintext-Scale Fair Data Exchange
**Session**: Zero-Knowledge Proofs
**Concept**: Two parties exchanging data fairly — neither can cheat. Scales of justice with data/files on each side. Atomic swap of information. Balance and fairness.
**Abstract**: The Fair Data Exchange (FDE) protocol achieves atomic, pay-per-file exchange with a constant on-chain footprint. We present implementations that reduce verification to O(λ).

---

### Paper #95 — Bribers, Bribers on The Chain
**Session**: Consensus & Smart Contracts
**Concept**: Bribery on a blockchain — shadowy figures offering coins to validators/voters. A chain with some links being corrupted by external payments. Dark money flowing into consensus.
**Abstract**: We study bribery attacks on blockchain protocols, analyzing how adversaries can use on-chain mechanisms to bribe participants.

---

### Paper #104 — Minimizing the Use of the Honest Majority in YOSO MPC
**Session**: Consensus & Smart Contracts
**Concept**: Multi-party computation with minimal honest majority. YOSO = "You Only Speak Once" — participants each speaking once then disappearing. Ephemeral nodes, minimal trust assumptions.
**Abstract**: We study how to minimize reliance on honest majority assumptions in the YOSO (You Only Speak Once) model of secure multi-party computation.

---

### Paper #105 — V3rified: Revelation vs Non-Revelation Mechanisms
**Session**: Incentives & Decentralization
**Concept**: Two contrasting mechanism designs — one where participants reveal private information, one where they don't. Transparency vs privacy in mechanism design. Two paths diverging.
**Abstract**: We study the comparison between revelation and non-revelation mechanisms in decentralized settings, particularly for Uniswap V3-style concentrated liquidity.

---

### Paper #108 — Compliance as a Trust Metric
**Session**: Privacy & Trust
**Concept**: Trust built from compliance — a web/network of trust relationships where compliance records form the foundation. Objective metrics replacing subjective ratings. Measurement and verification.
**Abstract**: Trust and Reputation Management Systems rely on subjective ratings or narrow QoS metrics. We propose compliance — adherence to agreed standards — as an objective trust metric.

---

### Paper #112 — Kite: How to Delegate Voting Power Privately
**Session**: Privacy & Trust
**Concept**: A kite flying — voting power being delegated upward through strings, but the connections are hidden/private. Anonymous delegation chains. Ballots with invisible threads.
**Abstract**: We present Kite, a system for private delegation of voting power in governance systems, where delegations remain hidden while votes are correctly tallied.

---

### Paper #113 — Delegated Fair Exchange via Threshold Wallets
**Session**: Threshold & Encryption
**Concept**: A wallet split into threshold shares, enabling fair exchange through delegation. Key fragments held by multiple parties, combining to authorize a fair trade.
**Abstract**: We construct fair exchange protocols using threshold wallet signatures, where exchange fairness is guaranteed by the threshold structure.

---

### Paper #117 — Where Does MEV Really Come From?
**Session**: DeFi & AMMs
**Concept**: MEV (Maximal Extractable Value) — value being extracted from transaction ordering. A magnifying glass examining a block of transactions, revealing hidden value flows between them.
**Abstract**: We analyze the fundamental sources of MEV, providing mathematical frameworks for understanding where extractable value originates in DeFi protocols.

---

### Paper #123 — On Stabilizing the Staking Rate
**Session**: PoS & Block Production
**Concept**: A staking rate oscillating and being stabilized — like a thermostat or PID controller for blockchain economics. Supply/demand curves reaching equilibrium.
**Abstract**: We study mechanisms for stabilizing the staking rate in proof-of-stake blockchains, analyzing how protocol parameters affect staking equilibria.

---

### Paper #128 — Reuse of Public Keys Across UTXO and Account-Based Cryptocurrencies
**Session**: Nonce and Key Reuse
**Concept**: A single key being used across two different lock types (UTXO padlock vs account-based digital lock). Cross-chain key reuse risks. One key, two incompatible doors.
**Abstract**: We analyze the security implications of reusing public keys across UTXO-based (Bitcoin) and account-based (Ethereum) cryptocurrencies.

---

### Paper #137 — A Theoretical Approach to Stablecoin Design via Price Windows
**Session**: DeFi & AMMs
**Concept**: A stablecoin price bouncing within defined windows/bands. Price corridors, stability mechanisms pulling the price back to the peg. Guardrails on a price chart.
**Abstract**: We present a theoretical framework for stablecoin design using price windows — defined ranges within which the stablecoin price should remain.

---

### Paper #141 — Rationally Analyzing Shelby
**Session**: Incentives & Decentralization
**Concept**: Game-theoretic analysis of a protocol named Shelby. Strategic players making rational decisions, Nash equilibria, payoff matrices. Chess-like strategic thinking applied to blockchain.
**Abstract**: We provide a rational analysis of the Shelby protocol, studying participant incentives and equilibrium behavior.

---

### Paper #146 — SoK: Lookup Table Arguments
**Session**: Zero-Knowledge Proofs
**Concept**: Lookup tables being used as building blocks for zero-knowledge proofs. A systematic survey — multiple approaches laid out and compared. Tables, indices, and proof structures organized.
**Abstract**: A systematization of knowledge covering lookup table arguments, a key building block in modern zero-knowledge proof systems.

---

### Paper #147 — Efficient Privacy-Preserving Blueprints for Threshold Comparison
**Session**: Privacy & Trust
**Concept**: Two values being compared without revealing either — a scale where both sides are hidden behind curtains but the comparison result is visible. Private threshold testing.
**Abstract**: We construct efficient privacy-preserving blueprints that allow threshold comparison — determining whether a value exceeds a threshold without revealing the value.

---

### Paper #156 — Adaptively Secure Threshold ElGamal Decryption from DDH
**Session**: Threshold & Encryption
**Concept**: ElGamal encryption split across threshold parties, secure even against adaptive corruption. A shield/lock that remains secure as parts of it are attacked one by one.
**Abstract**: We construct adaptively secure threshold ElGamal decryption from the DDH assumption, where the adversary can corrupt parties during protocol execution.

---

### Paper #166 — AI Agent Smart Contract Exploit Generation
**Session**: AI and ML Security
**Concept**: An AI agent probing smart contracts for vulnerabilities. Robot/AI figure examining code, finding cracks and exploits. Automated security testing meets adversarial AI.
**Abstract**: We study how AI agents can automatically generate exploits for smart contract vulnerabilities, evaluating their effectiveness.

---

### Paper #171 — Minimmit: Fast Finality with Even Faster Blocks
**Session**: Consensus — Fast Finality
**Concept**: Blocks being produced rapidly while finality follows close behind. A speedometer or racing metaphor — fast block times with quick confirmation. Two speeds: fast and faster.
**Abstract**: We present Minimmit, a consensus protocol achieving fast finality while supporting even faster block production times.

---

### Paper #179 — The Free Option Problem of ePBS
**Session**: PoS & Block Production
**Concept**: An option contract embedded in block building — the builder gets a free call option on block content. Financial derivatives imagery meets block production pipeline.
**Abstract**: We formalize the free option problem in enshrined Proposer-Builder Separation (ePBS), where builders gain optionality at proposers' expense.

---

### Paper #186 — Low-Latency Dynamically Available Total Order Broadcast
**Session**: Consensus — Fast Finality
**Concept**: Messages being broadcast and ordered with minimal delay, even as nodes join and leave. A sorting/ordering pipeline with streams of messages being rapidly sequenced.
**Abstract**: We present a total order broadcast protocol that achieves low latency while being dynamically available — tolerating participants going offline.

---

### Paper #187 — L for the Price of One
**Session**: Threshold & Encryption
**Concept**: Getting L instances/outputs from a single cryptographic operation. Multiplication/amplification from one to many. Efficiency — one coin splitting into L coins.
**Abstract**: We construct protocols where L threshold operations can be performed for essentially the cost of one.

---

### Paper #190 — Post-Quantum Readiness in EdDSA Chains
**Session**: Post-Quantum Cryptography
**Concept**: EdDSA signatures being protected against quantum computers. A shield around existing signatures with a quantum computer looming. Migration/upgrade pathway visualization.
**Abstract**: We study post-quantum readiness of blockchain systems using EdDSA, analyzing migration strategies and hybrid approaches.

---

### Paper #197 — Latency Advantages in Common-Value Auctions
**Session**: DeFi & AMMs
**Concept**: Speed advantage in auctions — faster participants gaining edge in common-value settings. Racing clocks, latency arrows, first-mover advantage in bidding.
**Abstract**: We analyze how latency advantages affect outcomes in common-value auctions, relevant to MEV and DeFi auction mechanisms.

---

### Paper #209 — Real AI Agents with Fake Memories
**Session**: AI and ML Security
**Concept**: An AI agent whose memory has been tampered with — false memories injected. A brain/neural network with some nodes highlighted as corrupted/fake. Trust and memory integrity.
**Abstract**: We study attacks where AI agents are given fabricated memories, affecting their behavior and decision-making.

---

### Paper #212 — Does Your Blockchain Need Multidimensional Transaction Fees
**Session**: Incentives & Decentralization
**Concept**: Transaction fees as a multidimensional space — not just one gas price but multiple resource dimensions (compute, storage, bandwidth) each with their own price axis. 3D fee space.
**Abstract**: We analyze when blockchains benefit from multidimensional transaction fee mechanisms versus simpler single-dimensional pricing.

---

### Paper #216 — A Trilemma in AMM Mechanism Design
**Session**: DeFi & AMMs
**Concept**: A trilemma triangle — three desirable properties where you can only achieve two. Classic impossible triangle applied to AMM design. Three corners in tension.
**Abstract**: We identify a fundamental trilemma in automated market maker mechanism design, showing three desirable properties that cannot be simultaneously achieved.

---

### Paper #220 — Routing Attacks in Ethereum PoS: A Systematic Exploration
**Session**: PoS & Block Production
**Concept**: Network routing being manipulated — BGP hijacking or path manipulation targeting Ethereum validators. Network topology with some paths being redirected/intercepted.
**Abstract**: We systematically explore routing attacks against Ethereum's proof-of-stake protocol, analyzing how network-level adversaries can disrupt consensus.

---

### Paper #223 — Revisiting Post-quantum Robustly Reusable Fuzzy Extractors
**Session**: Post-Quantum Cryptography
**Concept**: Fuzzy extractors — deriving consistent cryptographic keys from noisy biometric/physical data, even against quantum adversaries. Noise being cleaned into a stable key.
**Abstract**: We revisit fuzzy extractors in the post-quantum setting, constructing schemes that remain secure when the source is reused across multiple extractions.

---

### Paper #224 — STAR: Stylized and Transferable Adversarial Robustness
**Session**: AI and ML Security
**Concept**: Adversarial robustness that transfers across models/styles. A star shape as a shield, protecting against adversarial perturbations. Style transfer meets security.
**Abstract**: We present STAR, a framework for creating adversarial robustness that is both stylized and transferable across different models and domains.

---

### Paper #229 — Efficient Byzantine Agreement in the Presence of Omission Faults
**Session**: Consensus — Fast Finality
**Concept**: Byzantine generals reaching agreement, but some messages are silently dropped (omission). Missing messages, gaps in communication, yet consensus emerging despite the gaps.
**Abstract**: We construct efficient Byzantine agreement protocols that tolerate omission faults — where parties may fail to send or receive messages.

---

### Paper #231 — Beyond Winner-Take-All Procurement Auctions
**Session**: PoS & Block Production
**Concept**: An auction where multiple participants win, not just one. Distributed rewards instead of winner-take-all. Multiple bidders each getting a slice. Fairness in competition.
**Abstract**: We study procurement auction designs that go beyond winner-take-all, distributing work and rewards across multiple participants.

---

### Paper #239 — Efficient Partially Blind Signatures from Isogenies
**Session**: Post-Quantum Cryptography
**Concept**: Partially blind signatures — a signature where part of the message is visible and part is hidden. Isogeny-based crypto: elliptic curves connected by isogenies (morphisms between curves).
**Abstract**: We construct efficient partially blind signature schemes from isogenies, providing post-quantum security with practical performance.

---

### Paper #240 — The Last Challenge Attack
**Session**: Zero-Knowledge Proofs
**Concept**: An attack targeting the final challenge in an interactive proof. A series of challenges with the last one being exploited. A chain of proof rounds with the final link being broken.
**Abstract**: We present the Last Challenge Attack on interactive zero-knowledge proof systems, exploiting the final challenge round.

---

### Paper #252 — SoK: Approximate Agreement
**Session**: Consensus & Smart Contracts
**Concept**: Approximate agreement — nodes converging to nearly (but not exactly) the same value. Convergence visualization, values approaching each other asymptotically. A systematization survey.
**Abstract**: A systematization of knowledge covering approximate agreement protocols, where parties converge to values within some tolerance.

---

### Paper #253 — LLMs as verification oracles for Solidity
**Session**: AI and ML Security
**Concept**: An LLM reading and verifying Solidity smart contract code. AI as a code auditor — a robot with a magnifying glass examining contract logic for correctness.
**Abstract**: We study using large language models as verification oracles for Solidity smart contracts, evaluating their ability to check correctness properties.

---

### Paper #258 — Updatable Public-Key Encryption from Class Groups
**Session**: Threshold & Encryption
**Concept**: Public keys that can be updated/rotated while maintaining encrypted data. Class groups (algebraic structures) as the mathematical foundation. Key evolution over time.
**Abstract**: We construct updatable public-key encryption from class groups, allowing keys to be updated while maintaining decryption capability for previously encrypted data.
