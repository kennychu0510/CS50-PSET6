from cs50 import get_string

text = get_string("Text: ")

sentenceEnd = ['!', '?', '.']

letters = 0
sentences = 0
words = 1

# count for number of letters in text
for letter in text:
    if letter.isalpha():
        letters += 1

# count for number of sentences
    if letter in sentenceEnd:
        sentences += 1

    if letter == ' ':
        words += 1


print(f"letters: {letters}")
print(f"words: {words}")
print(f"sentences: {sentences}")
# Coleman-Liau: index 0.0588 * L - 0.296 * S - 15.8

l = letters / words * 100
s = sentences / words * 100

# print grade:
index = round(0.0588 * l - 0.296 * s - 15.8)
if index < 1:
    print("Before Grade 1")
elif index >= 16:
    print("Grade 16+")
else:
    print(f"Grade: {index}")