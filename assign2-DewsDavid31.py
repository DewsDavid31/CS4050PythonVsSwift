"""
Assign 02 - David Dews

Directions:
    * Complete the sorting algorithm functions that are given below. Note that
      it okay (and probably helpful) to define auxiliary/helper functions that
      are called from the functions below.  Refer to the README.md file for
      additional info.

    * NOTE: Remember to add a docstring for each function, and that a reasonable
      coding style is followed (e.g. blank lines between functions).
      Your program will not pass the tests if this is not done!

    * Be sure that you implement your own sorting functions since.
      No credit will be given if Python's built-in sort function is used.
"""

import time
import random
import sys
from math import ceil, log10

# Set recursion limit to be greater than the max size of any list you attempt to sort
sys.setrecursionlimit(10000)


def bubbleSort(list_of_items):
    """ Sorts list of integers by swapping each pair across"""
    start_time = time.time()

    # INSERT YOUR BUBBLE SORT CODE HERE
    for offset in range(1, len(list_of_items)):
        for index in range(len(list_of_items) - offset):
            if list_of_items[index] > list_of_items[index + 1]:
                temp = list_of_items[index]
                list_of_items[index] = list_of_items[index + 1]
                list_of_items[index + 1] = temp

    elapsed_time = time.time() - start_time
    return (list_of_items, elapsed_time)


def mergeSort(list_of_items, split_by_3=False):
    """ Sorts by dividing list until singleton and inserting pairs"""
    start_time = time.time()

    # INSERT YOUR MERGE SORT CODE HERE...
    #   * SPLITTING BY 2 WHEN split_by_3 = False
    #   * SPLITTING BY 3 WHEN split_by_3 = True
    list_of_items = _merge_sort_recursive(list_of_items, split_by_3)
    elapsed_time = time.time() - start_time
    return (list_of_items, elapsed_time)


def _split_by_3_(list_of_items):
    """ Private helper method for splitting lists in 3"""
    third = round(len(list_of_items) / 3)
    double = third * 2
    return list_of_items[:third], list_of_items[third:double], list_of_items[double:]


def _split_by_2_(list_of_items):
    """ Private helper method for splitting lists in half"""
    halfway = round(len(list_of_items) / 2)
    return list_of_items[:halfway], list_of_items[halfway:]


def _merge_(left, right):
    """ Private helper method that merges two lists in order"""
    temp = left + right
    left_index, right_index, temp_index = 0, 0, 0
    while left_index < len(left) and right_index < len(right):
        left_item = left[left_index]
        right_item = right[right_index]
        if left_item < right_item:
            temp[temp_index] = left_item
            left_index += 1
        else:  # right is smallest
            temp[temp_index] = right_item
            right_index += 1
        temp_index += 1
    while left_index < len(left):
        temp[temp_index] = left[left_index]
        left_index += 1
        temp_index += 1
    while right_index < len(right):
        temp[temp_index] = right[right_index]
        right_index += 1
        temp_index += 1
    return temp


def _merge_sort_recursive(list, by_3):
    """ Private recursive helper function for mergeSort calls"""
    if len(list) <= 1:
        return list
    elif by_3:
        first, second, third = _split_by_3_(list)
        return (_merge_(_merge_(_merge_sort_recursive(first, by_3), _merge_sort_recursive(second, by_3)),
                        _merge_sort_recursive(third, by_3)))
    else:
        first, second = _split_by_2_(list)
        return _merge_(_merge_sort_recursive(first, by_3), _merge_sort_recursive(second, by_3))


def quickSort(list_of_items, pivot_to_use='first'):
    """ Sorts list of integers by repeatedly picking a pivot and splitting list over it"""
    start_time = time.time()
    # INSERT YOUR QUICK SORT CODE HERE...
    #  * USING FIRST ITEM IN THE LIST AS THE PIVOT WHEN pivot_to_use = 'first'
    #  * USING MIDDLE ITEM IN THE LIST AS THE PIVOT WHEN pivot_to_use != 'first'
    # AND BE SURE THAT CONTINUES FOR SUBSEQUENT/RECURSIVE CALLS AS WELL
    new_list = _quick_sort_recursive_(list_of_items, pivot_to_use)
    elapsed_time = time.time() - start_time
    return (new_list, elapsed_time)


def _quick_sort_recursive_(list_of_items, pivot_to_use):
    """ Private recursive helper method for QuickSort calls"""
    if len(list_of_items) <= 1:
        return list_of_items
    pivot = 0
    if not pivot_to_use == 'first':
        pivot = round(len(list_of_items) / 2)
    right = []
    left = []
    pivot_val = list_of_items[pivot]
    for item in list_of_items:
        if item > pivot_val:
            right.append(item)
        elif item < pivot_val:
            left.append(item)
    return _quick_sort_recursive_(left, pivot_to_use) + [pivot_val] + _quick_sort_recursive_(right, pivot_to_use)


def radixSort(list_of_items, max_digits):
    """ Sorts a list of integers by comparing chars and binning elements"""
    start_time = time.time()

    # INSERT YOUR RADIX SORT CODE HERE
    padded_list = []
    buckets = []
    resulting_list = []
    for item in list_of_items:
        padded_list.append(_pad_(item, max_digits))
    for item in padded_list:
        _place_(buckets, item)
    _traverse_(buckets, resulting_list)

    elapsed_time = time.time() - start_time
    return (resulting_list, elapsed_time)


def _place_(buckets, item):
    """ Private helper method for radixSort that upserts arrays for bins"""
    for index in range(len(item)):
        char = item[index]
        digit = int(char)
        while len(buckets) <= digit:
            buckets.append([])
        if type(buckets[digit]) != list:
            buckets[digit] = []
        if index == len(item) - 1:
            buckets[digit].append(int(item))
        buckets = buckets[digit]


def _traverse_(bucket, result):
    """ Private helper method for radixSort that traverses the list of bins in order"""
    if isinstance(bucket, int):
        result.append(bucket)
    if isinstance(bucket, list):
        for sub_bucket in bucket:
            _traverse_(sub_bucket, result)


def _pad_(item, size):
    """ Private helper method for radixSort that pads up to size with leading '0'"""
    current_size = len(str(item))
    if current_size > size:
        return str(item)
    else:
        return "0" * (size - current_size) + str(item)


def assign02_main():
    """ A 'main' function to be run when our program is run standalone """
    list1 = list(range(5000))
    random.seed(1)
    random.shuffle(list1)

    # list1 = [54, 26, 93, 17, 77, 31, 44, 55, 20] # helpful for early testing

    # run sorting functions
    bubbleRes = bubbleSort(list(list1))
    mergeRes2 = mergeSort(list(list1), split_by_3=False)
    mergeRes3 = mergeSort(list(list1), split_by_3=True)
    quickResA = quickSort(list(list1), pivot_to_use='first')
    quickResB = quickSort(list(list1), pivot_to_use='middle')
    radixRes = radixSort(list(list1), ceil(log10(max(list1))))

    # Print results
    print(f"\nlist1 results (randomly shuffled w/ size = {len(list1)})")
    print(list1[:10])
    print(f"  bubbleSort time: {bubbleRes[1]:.4f} sec")
    print(bubbleRes[0][:10])
    print(f"  mergeSort2 time: {mergeRes2[1]:.4f} sec")
    print(mergeRes2[0][:10])
    print(f"  mergeSort3 time: {mergeRes3[1]:.4f} sec")
    print(mergeRes3[0][:10])
    print(f"  quickSortA time: {quickResA[1]:.4f} sec")
    print(quickResA[0][:10])
    print(f"  quickSortB time: {quickResB[1]:.4f} sec")
    print(quickResB[0][:10])
    print(f"  radixSort time: {radixRes[1]:.4f} sec")
    print(radixRes[0][:10])

    # Try with a list sorted in reverse order (worst case for quicksort)
    list2 = list(range(6000, 1000, -1))

    # run sorting functions
    bubbleRes = bubbleSort(list(list2))
    mergeRes2 = mergeSort(list(list2), split_by_3=False)
    mergeRes3 = mergeSort(list(list2), split_by_3=True)
    quickResA = quickSort(list(list2), pivot_to_use='first')
    quickResB = quickSort(list(list2), pivot_to_use='middle')
    radixRes = radixSort(list(list2), ceil(log10(max(list2))))

    # Print results
    print(f"\nlist2 results (sorted in reverse w/ size = {len(list2)})")
    print(list2[:10])
    print(f"  bubbleSort time: {bubbleRes[1]:.4f} sec")
    print(bubbleRes[0][:10])
    print(f"  mergeSort2 time: {mergeRes2[1]:.4f} sec")
    print(mergeRes2[0][:10])
    print(f"  mergeSort3 time: {mergeRes3[1]:.4f} sec")
    print(mergeRes3[0][:10])
    print(f"  quickSortA time: {quickResA[1]:.4f} sec")
    print(quickResA[0][:10])
    print(f"  quickSortB time: {quickResB[1]:.4f} sec")
    print(quickResB[0][:10])
    print(f"  radixSort time: {radixRes[1]:.4f} sec")
    print(radixRes[0][:10])


# Check if the program is being run directly (i.e. not being imported)
if __name__ == '__main__':
    assign02_main()
