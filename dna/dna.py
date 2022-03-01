import csv
import sys


def main():

    # TODO: Check for command-line usage
    if len(sys.argv) != 3:
        sys.exit("Usage: python dna.py data.csv sequence.txt")

    # TODO: Read database file into a variable\
    str_database = []
    with open(sys.argv[1], "r") as file:
        persons = csv.DictReader(file)
        for person in persons:
            for str in person:
                if str != "name":
                    person[str] = int(person[str])
            str_database.append(person)

    # TODO: Read DNA sequence file into a variable

    with open(sys.argv[2], "r") as file:
        dna = file.read()

    # TODO: Find longest match of each STR in DNA sequence

    str_count = {}
    for key in str_database[0]:
        if key != "name":
            str_count[key] = 0


    for str in str_count:
        str_count[str] = longest_match(dna, str)

    # TODO: Check database for matching profiles

    found = False
    lenOfStr = len(str_count)

    for person in str_database:
        match = 0
        for str in str_count:
            if person[str] == str_count[str]:
                match +=1

        # check if all str matches
        if match == lenOfStr:
            print(person["name"])
            found = True
            break

    if not found:
        print("No match")

    return


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


main()
