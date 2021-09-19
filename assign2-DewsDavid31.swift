// Assign 02, translated into swift to the best of my ability
import Foundation

assign02_main()
typealias split3Ways = (first: [Int], second: [Int], third: [Int])
typealias tuple = (list: [Int], time: Float)
typealias split2Ways = (first: [Int], second: [Int])


func bubbleSort(listOfItems: [Int]) -> tuple {
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
	let startTime = DispatchTime.now().uptimeNanoseconds
	let nextList = listOfItems
	let tempList = mergeSortRecursive(listOfItems: nextList,splitBy3: splitBy3)
	let endTime = DispatchTime.now().uptimeNanoseconds
	return tuple(list: tempList, time: ((Float(endTime) - Float(startTime))/1000000000))
}

func mergeSortRecursive(listOfItems: [Int], splitBy3: Bool) -> [Int]{
	if(listOfItems.count <= 1){
		return listOfItems
	}
	else if(splitBy3){
		let splittedList = splitTo3(listOfItems: listOfItems)
		return merge(left: merge(left: mergeSortRecursive(listOfItems: splittedList.first,splitBy3: splitBy3),right:  mergeSortRecursive(listOfItems: splittedList.second,splitBy3: splitBy3)),right: mergeSortRecursive(listOfItems: splittedList.third,splitBy3: splitBy3))
	}
	let splittedList = splitTo2(listOfItems: listOfItems)
	return merge(left: mergeSortRecursive(listOfItems: splittedList.first,splitBy3: splitBy3),right: mergeSortRecursive(listOfItems: splittedList.second,splitBy3: splitBy3))
}

func merge(left: [Int], right: [Int]) -> [Int] {
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
	let halfway = Int(ceil(Double(listOfItems.count) / Double(2)))
	return split2Ways(first: Array<Int>(listOfItems[0..<halfway]), second: Array<Int>(listOfItems[halfway..<listOfItems.count]))
}

func splitTo3(listOfItems: Array<Int>) -> split3Ways {
	let third = Int(ceil(Double(listOfItems.count) / Double(3)))
	let double = third * 2
	return split3Ways(first: Array<Int>(listOfItems[0..<third]), second: Array<Int>(listOfItems[third..<double]), third: Array<Int>(listOfItems[double..<listOfItems.count]))
}


func quickSort(listOfItems: [Int], pivotToUse: String) -> tuple {
	let startTime = DispatchTime.now().uptimeNanoseconds
	let endTime = DispatchTime.now().uptimeNanoseconds
	let tempList = quickSortRecursive(listOfItems: listOfItems, pivotToUse: pivotToUse)
	return tuple(list: tempList, time: ((Float(endTime) - Float(startTime))/1000000000))
}

func quickSortRecursive(listOfItems: [Int], pivotToUse: String) -> [Int] {
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
	let startTime = DispatchTime.now().uptimeNanoseconds
	let endTime = DispatchTime.now().uptimeNanoseconds
	//TODO: do me
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
