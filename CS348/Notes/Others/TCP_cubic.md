**TCP Cubic** is a congestion control algorithm used in TCP that is designed to optimize performance in high-bandwidth, high-latency networks (often called long fat networks or LFNs). Unlike traditional congestion control algorithms like TCP Reno, which rely primarily on linear window growth, Cubic uses a cubic function to control its congestion window size. 

### Key Features of TCP Cubic

1. **Cubic Window Growth Function**:
   - The main idea behind TCP Cubic is its **cubic function** growth for the congestion window (`W_cubic`). This function ensures that the growth of the congestion window is **non-linear** and provides faster recovery and better scalability in high-speed networks.

   The growth function is defined as:
   \[
   W_{cubic}(t) = C \times (t - K)^3 + W_{max}
   \]
   Where:
   - \(W_{cubic}(t)\): Congestion window size at time \(t\).
   - \(C\): A constant that determines the aggressiveness of the window growth.
   - \(t\): Time since the last window reduction event (e.g., loss).
   - \(K\): Time period it would take to reach \(W_{max}\) again after a loss.
   - \(W_{max}\): The congestion window size before the last loss event.

   The cubic function ensures **slow growth near \(W_{max}\)** (to probe the network capacity) and **faster growth** when the window size is far from \(W_{max}\).

### Phases of TCP Cubic

1. **Slow Start**:
   - Like other TCP variants, Cubic begins in **Slow Start** mode.
   - The congestion window (`cwnd`) increases exponentially until it hits the slow start threshold (`ssthresh`).
   - This phase aims to quickly discover the available bandwidth.

   During this phase:
   \[
   cwnd = cwnd + 1 \text{ (per ACK received)}
   \]

2. **Congestion Avoidance**:
   - Once `cwnd` reaches `ssthresh`, Cubic enters the **congestion avoidance phase**.
   - Unlike Reno, which grows linearly, Cubic uses its cubic growth function. The growth rate varies based on the current window size relative to \(W_{max}\):
     - **Near \(W_{max}\)**: Growth is slower to avoid overshooting the network capacity.
     - **Far from \(W_{max}\)**: Growth is faster to utilize the available bandwidth efficiently.

3. **Parameter Updates on Packet Loss**:

   - **At Triple Duplicate ACKs (Indicating Mild Congestion)**:
     - Triple duplicate ACKs usually imply packet reordering or mild congestion, so Cubic reduces its window but not as aggressively as on a timeout.
     - **Actions**:
       - The **maximum window size** \(W_{max}\) is updated to the current `cwnd`.
       - The **new `ssthresh`** is set to \(\frac{cwnd}{2}\).
       - The **congestion window** (`cwnd`) is reduced to \(W_{max} \times (1 - \beta)\), where \(\beta\) is typically **0.7** in Cubic (reducing to 70%).
         \[
         W_{max} = cwnd
         \]
         \[
         ssthresh = \frac{cwnd}{2}
         \]
         \[
         cwnd = cwnd \times 0.7
         \]
       - This moderate reduction helps the network recover more quickly without sacrificing much throughput.

   - **At Timeout (Indicating Severe Congestion)**:
     - A timeout suggests severe congestion or loss of multiple packets, so the reduction is more aggressive.
     - **Actions**:
       - The **maximum window size** \(W_{max}\) is updated to the current `cwnd`.
       - The **new `ssthresh`** is set to \(\frac{cwnd}{2}\).
       - The **congestion window** (`cwnd`) is reset to 1 (restart in slow start mode).
         \[
         W_{max} = cwnd
         \]
         \[
         ssthresh = \frac{cwnd}{2}
         \]
         \[
         cwnd = 1
         \]

4. **Fast Recovery**:
   - If packet loss is detected via **triple duplicate ACKs**, Cubic enters **Fast Recovery** mode instead of reducing `cwnd` to 1.
   - In Fast Recovery:
     - The window is reduced moderately, allowing Cubic to quickly recover without significant throughput loss.
     - The congestion window grows using the cubic function until it reaches \(W_{max}\), and then it grows linearly afterward.

### Differences from Other TCP Variants

1. **Cubic Growth**:
   - Traditional TCP variants like **Reno** use a **linear increase** of the congestion window during congestion avoidance, increasing by one packet per RTT (Round Trip Time).
   - **TCP Cubic** uses a **cubic function** to accelerate growth when far from \(W_{max}\) and slow it down when approaching \(W_{max}\).

2. **Handling High Bandwidth-Delay Products**:
   - Cubic is particularly effective in networks with **high bandwidth-delay products** because its cubic growth function can quickly adapt to the available capacity.

3. **Less Aggressive Reduction**:
   - On detecting mild congestion (triple duplicate ACKs), Cubic reduces the window size less aggressively compared to Reno. This helps maintain higher throughput and quickly probe the network capacity again.

### Summary of Key Parameters

| Event                  | `W_max` Update       | `cwnd` Update            | `ssthresh` Update         |
|------------------------|----------------------|--------------------------|---------------------------|
| **Slow Start**         | -                    | Exponential Growth       | -                         |
| **Congestion Avoidance** | Set before loss     | Cubic Growth Function    | -                         |
| **Triple Dup ACKs**    | \(W_{max} = cwnd\)   | \(cwnd \times 0.7\)      | \(\frac{cwnd}{2}\)        |
| **Timeout**            | \(W_{max} = cwnd\)   | \(cwnd = 1\)             | \(\frac{cwnd}{2}\)        |

### Why TCP Cubic is Widely Used

TCP Cubic is the default congestion control algorithm in Linux because of its:
- **Efficiency** in high-speed, high-latency networks.
- **Better utilization** of available bandwidth without causing excessive congestion.
- **Smooth performance** in various network environments.

Cubic's dynamic adjustment based on its cubic growth function allows it to outperform traditional congestion control algorithms in many scenarios, especially where high throughput is required.