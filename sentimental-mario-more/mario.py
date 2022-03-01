from cs50 import get_int

x = get_int("Height: ")

while (x < 1 or x > 8):
    x = get_int("Height: ")

for i in range(x):

    # print left blanks
    for j in range(i+1, x):
        print(" ", end="")

    # print left hashes
    for j in range(x-i-1, x):
        print("#", end="")

    # print middle spaces
    print("  ", end="")

    # print right hashes
    for j in range(x-i-1, x):
        print("#", end="")

    print("")
