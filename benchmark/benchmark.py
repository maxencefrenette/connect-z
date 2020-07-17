from subprocess import run, PIPE
from statistics import mean

benchmarks = [
    "Test_L3_R1",
    # "Test_L2_R1",
    # "Test_L2_R2",
    # "Test_L1_R1",
    # "Test_L1_R2",
    # "Test_L1_R3",
]

run("zig build -Drelease-fast", check=True)

for benchmark in benchmarks:
    with open(f"./benchmark/data/{benchmark}") as file:
        positions = []
        scores = []

        for line in file:
            pos, score = line.split()
            positions.append(pos)
            scores.append(int(score))

    result = run(
        "zig build run -Drelease-fast",
        input="\n".join(positions),
        capture_output=True,
        check=True,
        text=True,
    )

    output = result.stdout.strip()
    lines = output.split("\n")

    nodes_explored_list = []
    time_taken_list = []

    for i, line in enumerate(lines):
        l = line.split()
        position, score, nodes_explored, time_taken = (
            l[0],
            int(l[1]),
            int(l[2]),
            int(l[3]),
        )

        if score is not scores[i]:
            print(f"Position {position}: expected {scores[i]}, got {score}")

        nodes_explored_list.append(nodes_explored)
        time_taken_list.append(time_taken)

    print(f"Average nodes explored: {mean(nodes_explored_list)}")
    print(f"Average time (s): {mean(time_taken_list) / 1000000}")
