# with open('src/day4.txt', 'r') as f:
#     data = f.readlines()


data = """\
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11""".split("\n")


winning_hands = []
my_hands = []

for card_i, line in enumerate(data):
  line = line.split(":")[1].strip()
  winning_cards, my_cards, *_ = line.split("|")
  winning_cards = winning_cards.strip().split(" ")
  my_cards = my_cards.strip().split(" ")
  winning_hands.append([int(c) for c in winning_cards if c])

  my_hands.append([int(c) for c in my_cards if c])
print(len(my_hands))
print(len(winning_hands))

total = 0
for w_cards, my_cards in zip(winning_hands, my_hands):
  score = sum([e in w_cards for e in my_cards])
  total += 2 ** (score - 1) if score > 0 else 0
print(total)

# p2
print("part 2")


def count_matches(l1, l2):
  return sum([e in l1 for e in l2])


n_cards = 0
n_copies = [1] * len(my_hands)
my_hands2 = my_hands.copy()
prev_total = total
k = 0
while True:
  n_total_matches = 0
  for i, (w_cards, my_cards) in enumerate(zip(winning_hands, my_hands)):
    n_matches = count_matches(w_cards, my_cards)
    my_new_cards = my_hands[i + 1 : min(i + n_matches + 1, len(my_hands))]
    for cards in my_new_cards:
      my_hands2[i].extend(cards)
    # we added n_matches hands.....
    n_total_matches += n_matches
  print(prev_total)
  if n_total_matches == prev_total and k > 0:
    break
  k += 1
  prev_total = n_total_matches
# for i, (w_cards, my_cards) in enumerate(zip(winning_hands, my_hands)):
#     n_matches = count_matches(w_cards, my_cards)
#     total_matches = n_matches

#     while (n_matches > 0):
#         my_new_cards = my_hands[i+1:min(i+n_matches+1, len(my_hands))]
#         print(my_new_cards)
#         n_matches = 0
#         for idx, cards in enumerate(my_new_cards):
#             matches_now = count_matches(w_cards, my_new_cards)
#             idx = i+idx+1
#             # my_new_cards = my_hands[idx+matches_now+1:min(idx+matches_now+1, len(my_hands))]
#             my_new_cards = my_hands[idx+1:min(idx+matches_now+1, len(my_hands))]
#             n_matches += matches_now
#         total_matches += n_matches

#     print('total_matches', total_matches)
#     n_cards += total_matches
# print()
# print(n_cards)
# for i, (w_cards, my_cards) in enumerate(zip(winning_hands, my_hands)):
#     n_matches = count_matches(w_cards, my_cards)
#     total_matches = n_matches
#     print('n_matches:', n_matches)

#     while (n_matches > 0):
#         curr_additional_hands = 0
#         for idx in range(i+1, i+n_matches):
#             n_copies[idx] += 1
#             matches_for_hand = count_matches(w_cards, my_hands[idx])
#             curr_additional_hands += matches_for_hand

#         my_new_cards = [x for row in my_hands[i+1:i+n_matches] for x in row]
#         n_matches = count_matches(w_cards, my_new_cards)
#         print('n_matches:', n_matches)
#         total_matches += n_matches

#     print('total_matches', total_matches)
#     n_cards += total_matches
# print()
# print(n_cards)
