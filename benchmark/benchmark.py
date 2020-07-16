from subprocess import run, PIPE

benchmarks = [
    "Test_L3_R1",
    "Test_L2_R1",
    "Test_L2_R2",
    "Test_L1_R1",
    "Test_L1_R2",
    "Test_L1_R3",
]

run("zig build -Drelease-fast", check=True)

for bench in benchmarks:
    result = run(
        "zig build run -Drelease-fast",
        stdin=open("./benchmark/data/Test_L3_R1"),
        check=True,
        capture_output=True,
        text=True,
    )

    output = result.stdout.strip()
    lines = output.split("\n")
    assert(len(lines) == 1000)
