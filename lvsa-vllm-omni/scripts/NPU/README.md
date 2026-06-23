## NPU validation benchmark

This benchmark was executed in a vllm-omni Docker container with the following software versions:

- **Python**: 3.11.14
- **CANN**: 8.5.1
- **vllm**: 0.18.0
- **vllm_ascend**: 0.18.0rc1
- **vllm-omni**: 0.18.0
- **lvsa**: 1.0.0
- **lvsa-vllm-omni**: 1.0.0
- **torch**: 2.9.0
- **torch_npu**: 2.9.0 

## Run 

Need 1 or 8 NPUs depending on the model and parallel configuration.

Run inside a vllm-omni checkout with the desired argument (base, lvsa or all benchmarks):

`bash run_benchmark_480.sh base`

`bash run_benchmark_480.sh lvsa`

`bash run_benchmark_480.sh all`

## Example Results

### 480p | Wan2.2-T2V-A14B-Diffusers (ulysses 8 hsdp)

| #frames | method | generation time (s) | iteration time avg (s) | speedup over base (avg iteration) |
|---------|--------|---------------------|------------------------|-----------------------------------|
| 161     | base   | 438                 | 10.29                  |                                   |
| 161     | lvsa   | 522                 | 12.42                  | 0.83                              |
|---------|--------|---------------------|------------------------|-----------------------------------|
| 321     | base   | 1287                | 30.93                  |                                   |
| 321     | lvsa   |  973                | 23.09                  | 1.34                              |
|---------|--------|---------------------|------------------------|-----------------------------------|
| 481     | base   | 2576                | 62.56                  |                                   |
| 481     | lvsa   | 1414                | 33.47                  | 1.87                              |

### 720p | Wan2.2-T2V-A14B-Diffusers (ulysses 8 hsdp)


| #frames | method | generation time (s) | iteration time avg (s) | speedup over base (avg iteration) |
|---------|--------|---------------------|------------------------|-----------------------------------|
| 161     | base   | 1672                | 40.38                  |                                   |
| 161     | lvsa   | 1532                | 36.95                  | 1.09                              |
|---------|--------|---------------------|------------------------|-----------------------------------|
| 321     | base   | 5641                | 138.31                 |                                   |
| 321     | lvsa   | 2884                |  69.38                 | 1.99                              |
|---------|--------|---------------------|------------------------|-----------------------------------|
| 481     | base   | 11932               | 294.22                 |                                   |
| 481     | lvsa   |  4255               | 102.37                 | 2.87                              |
