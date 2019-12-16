---
title: Doing Some Python Work in Biostats
author: ~
date: '2019-12-15'
slug: doing-some-python-work-in-biostats
categories: []
tags: []
subtitle: ''
summary: ''
authors: []
lastmod: '2019-12-15T17:36:51-06:00'
featured: yes
image:
  caption: ''
  focal_point: '' 
  preview_only: no

---

In Biostats we have been learning python. Python is a language with some snakes as the icon. (I'm going to remove the posts section of my website and use it as an actual resume) I have done several projects before in python, so instead of talking about what we've done in class, I'll talk about the python snippit I used to extract features from a dataset of random numbers. 

What this code must do is read in a csv file consisting of only one important column-the ten digit random number that was created by either a human or computer-and extract some features from it to use for building a prediction model.

First, the libraries we will use are the csv library and statistics library.

```python
import csv
import statistics 
```

The next step is to use the ```csv.DictReader``` function to read in the csv file as an iterable of dictionaries representing the rows and populate an array ```entries``` with these dictionaries.

```python
entries = []

csv.register_dialect('myDialect',delimiter = ',',quoting=csv.QUOTE_ALL,skipinitialspace=True)
with open('random_numbers.csv', 'r') as f:
    reader = csv.DictReader(f, dialect='myDialect')
    for row in reader:
        entries += [dict(row)]
```

Now that we have the contents of the csv file in the entries array, we can generate some features and store it back in the row dictionaries. We'll create a function ```addFeatures``` to take a row dictionary and calculate the features.

```python

def addFeatures(entry) :
    seq = entry['Number']
    while len(seq) < 10 :
        seq = '0' + seq
    
    # digit frequency
    max = 0
    for d in range(0,10) :
        count = 0
        for i in range(0, 10) :
            if str(d) == seq[i] :
                count += 1
        entry['count.'+str(d)] = count
        if count > max :
            max = count
    entry['count.max.duplicates'] = max

    # number of consecutive numbers
    count = 0
    for i in range(1, 10) :
        if int(seq[i]) == int(seq[i-1]) - 1 or int(seq[i]) == int(seq[i-1]) + 1 :
            count += 1
    entry['num.consecutive'] = count

    # derivative
    diff = []
    for i in range(1, 10) :
        diff += [int(seq[i]) - int(seq[i-1])]
    deriv = statistics.mean(diff)
    entry['derivative'] = int(deriv * 100) / 100
    entry['growth.direction'] = 'Increase' if deriv > 0 else ('Decrease' if deriv < 0 else 'Zero')

    # mean
    sum = 0
    for i in range(0, 10) :
        sum += int(seq[i])
    entry['mean'] = sum / 10

    # standard deviation
    entry['std.dev'] = int(statistics.stdev([int(seq[i]) for i in range(0, 10)]) * 1000) / 1000
    # even and odd
    entry['num.odd'] = len([int(seq[i]) for i in range(0, 10) if int(seq[i]) % 2 == 1])
    entry['num.even'] = len([int(seq[i]) for i in range(0, 10) if int(seq[i]) % 2 == 0])
    
    return entry

```

Now we will loop over the ```entries``` array replacing each element with the result of the ```addFeatures``` function.

```python
for i in range(0, len(entries)) :
    entries[i] = addFeatures(entries[i])
```

Finally, we can write the result back out as a new csv file with the new features included.

```python
with open('random_numbers_with_features.csv', mode='w') as csv_file:
    writer = csv.DictWriter(csv_file, fieldnames=entries[0].keys())

    writer.writeheader()
    for i in range(0, len(entries)) :
        writer.writerow(entries[i])
```

This new csv can then be imported into R for further development and for creating a prediction model. I'm sure I could've done all of this in R, but I chose to do it in python because I am more familiar with python and could do it with less googling.




