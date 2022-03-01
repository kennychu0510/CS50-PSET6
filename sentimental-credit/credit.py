from cs50 import get_string

number = get_string("Number: ")

length = len(number)

# Luhn's Algorithim
sum = 0

for i in range(length):

    # every digits that weren't multiplied by 2 (starting from the end)
    if i % 2 == 0:
        sum += int(number[length-1-i])

    # every other digit starting from the second-to-last digit
    else:
        x = 2 * int(number[length-1-i])
        if x >= 10:
            x = x // 10 + x % 10
        sum += x


if sum % 10 == 0:
    # check if AMEX:
    if number[0] == "3" and (number[1] == "4" or number[1] == "7"):
        print("AMEX")

    # check if MASTERCARD:
    elif number[0] == "5" and (int(number[1]) >= 1 and int(number[1]) <= 5):
        print("MASTERCARD")

    # check if VISA:
    elif (number[0] == "4"):
        print("VISA")
    else:
        print("INVALID")
else:
    print("INVALID")
