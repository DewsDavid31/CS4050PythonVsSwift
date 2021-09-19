// Assign 02, translated into swift to the best of my ability
import Foundation

assign02_main()
/// A main method call to best compare to python's main, called impertively 

typealias split3Ways = (first: [Int], second: [Int], third: [Int])
/// A struct is used in place multiple arrays being returned

typealias tuple = (list: [Int], time: Float)
/// A tuple struct had to be made for return values to be similar

typealias split2Ways = (first: [Int], second: [Int])
/// A separate struct had to be made for type sensitivity of the third array being absent


func bubbleSort(listOfItems: [Int]) -> tuple {
/**
	A method of sort using the swapping of two elements at a time
	
	Stackoverflow's suggested use of dispatch time leads to odd calculations of time
	
		- listOfItems: Int array needed to be sorted
		- returns: tuple struct of the sorted list as list member and float of time elapsed
		 as time member
*/
	var tempList = listOfItems
	let startTime = DispatchTime.now().uptimeNanoseconds
	for offset in 1..<listOfItems.count {
		for index in 0..<(listOfItems.count - offset) {
			if(tempList[index] > tempList[index + 1]){
				let temp = tempList[index]
				tempList[index] = tempList[index + 1]
				tempList[index + 1] = temp
			}
		}
	}
	let endTime = DispatchTime.now().uptimeNanoseconds
	return tuple(list: tempList, time: ((Float(endTime) - Float(startTime))/1000000000))
}

func mergeSort(listOfItems: [Int], splitBy3: Bool) -> tuple{
/**
	A method of sort of dividing a list and merging back in order
	
		- listOfItems: Int array of unsorted numbers
		splitBy3: a boolean flag where:
			- true: mergeSort splits list into 3
			- false: mergeSort splits list into 2
	
	for simplicity of code, merge only merges in batches of 2 at a time
	Dispatch time has odd innaccuracies
	
		- returns: tuple struct with list as the sorted integer array and time as the elapsed time 
*/
	let startTime = DispatchTime.now().uptimeNanoseconds
	let nextList = listOfItems
	let tempList = mergeSortRecursive(listOfItems: nextList,splitBy3: splitBy3)
	let endTime = DispatchTime.now().uptimeNanoseconds
	return tuple(list: tempList, time: ((Float(endTime) - Float(startTime))/1000000000))
}

func mergeSortRecursive(listOfItems: [Int], splitBy3: Bool) -> [Int]{
/**
	A recursive helper function for merge sort to allow timing to be possible
	
		- listOfItems: current unsorted array of integers
		
		- splitBy3: boolean flag on if next split should be in thirds or halves
			- true: splint int array into 3 pieces
			- false: splint int array into half
	merge still only merges pairs of 2, but combines one pair if split by 3 to make work
*/
	if(listOfItems.count <= 1){
		return listOfItems
	}
	else if(splitBy3){
		let splittedList = splitTo3(listOfItems: listOfItems)
		// HOLY LABELS BATMAN!! we recursively call merge on splitted portions
		//  merging the right side since we have 3 pieces
		return merge(left: merge(left: mergeSortRecursive(listOfItems: splittedList.first,splitBy3: splitBy3),right:  mergeSortRecursive(listOfItems: splittedList.second,splitBy3: splitBy3)),right: mergeSortRecursive(listOfItems: splittedList.third,splitBy3: splitBy3))
	}
	let splittedList = splitTo2(listOfItems: listOfItems)
	return merge(left: mergeSortRecursive(listOfItems: splittedList.first,splitBy3: splitBy3),right: mergeSortRecursive(listOfItems: splittedList.second,splitBy3: splitBy3))
}

func merge(left: [Int], right: [Int]) -> [Int] {
/**
	helper method for merge step of merge sort, combines lists after finding maximums
		- left: current left side list from splitting portion
		
\		- right: current right side list from splitting portion
			- if splitBy3 is true, this side gets the middle and right portions
		
		- returns: int array of resulting merged list
*/
	var temp = left + right
	var leftIndex = 0
	var rightIndex = 0
	var tempIndex = 0
	if(temp.count <= 1){
		return temp
	}
	while(leftIndex < left.count && rightIndex < right.count){
		let leftItem = left[leftIndex]
		let rightItem = right[rightIndex]
		if(leftItem < rightItem) {
			temp[tempIndex] = leftItem
			leftIndex += 1
			tempIndex += 1
		}
		else{
			temp[tempIndex] = rightItem
			rightIndex += 1
			tempIndex += 1
		}
	}
	while(leftIndex < left.count){
		temp[tempIndex] = left[leftIndex]
		tempIndex += 1
		leftIndex += 1
	}
	while(rightIndex < right.count ){
		temp[tempIndex] = right[rightIndex]
		tempIndex += 1
		rightIndex += 1
	}
	return temp
}

func splitTo2(listOfItems: Array<Int>) -> split2Ways {
/**
	array splitting helper method only for splitting in half
	
		- listOfItems: int array needed to be split in half
	
		- returns: struct of both halfs in 'first' and 'second' members

	rounding was difficult to implement as easily as python
*/
	let halfway = Int(ceil(Double(listOfItems.count) / Double(2)))
	return split2Ways(first: Array<Int>(listOfItems[0..<halfway]), second: Array<Int>(listOfItems[halfway..<listOfItems.count]))
}

func splitTo3(listOfItems: Array<Int>) -> split3Ways {
/**
	array splitting helper method only for splitting int arrays into thirds
	
		- listOfITems: int array needed to be split into thirds
	
		- returns: struct of thirds in 'first', 'second' and 'third' members respectively

	rounding was difficult to implement as easily as python, and labeled arguments start to get unsightly

*/
	let third = Int(ceil(Double(listOfItems.count) / Double(3)))
	let double = third * 2
	return split3Ways(first: Array<Int>(listOfItems[0..<third]), second: Array<Int>(listOfItems[third..<double]), third: Array<Int>(listOfItems[double..<listOfItems.count]))
}


func quickSort(listOfItems: [Int], pivotToUse: String) -> tuple {
	/**
		sort using two arrays to place elements lesser or greater than a chosen value done recursively until sorted
		
			- listOfItems: unsorted int array
		
			- pivotToUse: String of choice of pivot options include:
				- 'middle': the middlemost element is chosen as pivot
				- 'first': the default option, picks the first element as pivot
		
		besides recursive calls being cumbersome with labeled arguments and countable ranges making slices
			 confusing was a breeze to translate
	*/
	let startTime = DispatchTime.now().uptimeNanoseconds
	let endTime = DispatchTime.now().uptimeNanoseconds
	let tempList = quickSortRecursive(listOfItems: listOfItems, pivotToUse: pivotToUse)
	return tuple(list: tempList, time: ((Float(endTime) - Float(startTime))/1000000000))
}

func quickSortRecursive(listOfItems: [Int], pivotToUse: String) -> [Int] {
	/**
		recursive helper function for quickSort such that elapsed time becomes easier to measure
		
			- listOfItems: unsorted array of integers
		
			- pivotToUse: String of chosen pivot method choices include:
				- 'middle': the middlemost element is chosen
				- 'first': the default option, the first element is chosen
		
			- returns: sorted array for the original function
	*/
	if(listOfItems.count <= 1){
		return listOfItems
	}
	var pivot = 0
	if(pivotToUse == "first"){
		pivot = Int(ceil(Double(listOfItems.count))/Double(2))
	}
	var right: [Int] = []
	var left: [Int] = []
	let pivotVal = listOfItems[pivot]
	for item in listOfItems{
		if(item > pivotVal){
			right.append(item)
		}
		else if(item < pivotVal){
			left.append(item)
		}
	}
	return quickSortRecursive(listOfItems: Array<Int>(left), pivotToUse: pivotToUse) + [pivotVal] + quickSortRecursive(listOfItems: Array<Int>(right), pivotToUse: pivotToUse)
}

func radixSort(listOfItems: [Int], maxDigits: Int) -> tuple {
/**
	A faster sort with the stipulation of a known range of values, uses characters to group elements until sorted
	
		- listOfItems: unsorted integer array
	
		- maxDigits: number of maximum characters in the array expected
	
		- returns: a tuple struct with list member being the sorted list and time member being the elapsed time
	
	translating this list was a pain, originally I attempted to 1:1 translate the method I used without any references,
	sadly that method requires character conversion which Swift is difficult to coerce characters at a specific index or
	call recursively on arrays of unknown types. I instead vied for a method used by Swift Datastructures book by using
		 modulo math instead
*/
	let startTime = DispatchTime.now().uptimeNanoseconds
	let endTime = DispatchTime.now().uptimeNanoseconds
	var tempList = listOfItems
	var base = 1
	var done = false
	while(!done){
		done = true
		var buckets: [[Int]] = .init(repeating: [], count: 10)
		for item in tempList{
			let remainingPart = item / base
			if(remainingPart > 0){
				done = false
			}
			let digit = remainingPart % 10
			buckets[digit].append(item)
		}
		base *= 10
		tempList = buckets.flatMap({$0})
	}
	return tuple(list: tempList, time: ((Float(endTime) - Float(startTime))/1000000000))
}

func assign02_main(){
/**
	Main method to be called on starting the program

	Creating a range of values was an interesting experience in this language as well as its version of printf
	The result is pleasingly similar to my original given code by the professor though
*/
	let listRange: CountableRange<Int> = 0..<5000
	var list1: [Int] = Array(listRange)
	list1.shuffle()
	


	var bubbleRes = bubbleSort(listOfItems: list1)
	var mergeRes2 = mergeSort(listOfItems: list1, splitBy3: false)
	var mergeRes3 = mergeSort(listOfItems: list1, splitBy3: true)
	var quickResA = quickSort(listOfItems: list1, pivotToUse: "first")
	var quickResB = quickSort(listOfItems: list1, pivotToUse: "middle")
	var radixRes = radixSort(listOfItems: list1, maxDigits: String(list1.max()!).count)

	var bubbleTime = String(format: "%.4f", bubbleRes.time)
	var merge2Time = String(format: "%.4f", mergeRes2.time)
	var merge3Time = String(format: "%.4f", mergeRes3.time)
	var quickATime = String(format: "%.4f", quickResA.time)
	var quickBTime = String(format: "%.4f", quickResB.time)
	var radixTime = String(format: "%.4f", radixRes.time)



	print("\nlist1 results (randomly shuffled w/ size = \(list1.count))")
	print(list1[..<10])
	print("  bubbleSort time: \(bubbleTime) sec")
	print(bubbleRes.list[..<10])
	print("  mergeSort time: \(merge2Time) sec")
	print(mergeRes2.list[..<10])
	print("  mergeSort2 time: \(merge3Time) sec")
	print(mergeRes3.list[..<10])
	print("  quickSortA time: \(quickATime) sec")
	print(quickResA.list[..<10])
	print("  quickSortB time: \(quickBTime) sec")
	print(quickResB.list[..<10])
	print("  radixSort time: \(radixTime) sec")
	print(radixRes.list[..<10])


	let listRange2: CountableRange<Int> = (1000..<6000)
	let list2: [Int] = Array(listRange2.reversed())
	
	bubbleRes = bubbleSort(listOfItems: list2)
	mergeRes2 = mergeSort(listOfItems: list2, splitBy3: false)
	mergeRes3 = mergeSort(listOfItems: list2, splitBy3: true)
	quickResA = quickSort(listOfItems: list2, pivotToUse:"first")
	quickResB = quickSort(listOfItems: list2, pivotToUse: "middle")
	radixRes = radixSort(listOfItems: list2, maxDigits: String(list2.max()!).count)

	bubbleTime = String(format: "%.4f", bubbleRes.time)
	merge2Time = String(format: "%.4f", mergeRes2.time)
	merge3Time = String(format: "%.4f", mergeRes3.time)
	quickATime = String(format: "%.4f", quickResA.time)
	quickBTime = String(format: "%.4f", quickResB.time)
	radixTime = String(format: "%.4f", radixRes.time)



	print("\nlist2 results (sorted in reverse w/ size = \(list2.count))")
	print(list2[..<10])
	print("  bubbleSort time: \(bubbleTime) sec")
	print(bubbleRes.list[..<10])
	print("  mergeSort time: \(merge2Time) sec")
	print(mergeRes2.list[..<10])
	print("  mergeSort2 time: \(merge3Time) sec")
	print(mergeRes3.list[..<10])
	print("  quickSortA time: \(quickATime) sec")
	print(quickResA.list[..<10])
	print("  quickSortB time: \(quickBTime) sec")
	print(quickResB.list[..<10])
	print("  radixSort time: \(radixTime) sec")
	print(radixRes.list[..<10])

}
