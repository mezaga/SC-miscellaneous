+SimpleNumber{
	partition2 { |parts = 2, min = 1|
		// randomly partition a number into parts of at least min size :
		var n = this - (min - 1 * parts);
		var res;
		res = (1..n-1).scramble.keep(parts-1).sort.add(n).differentiate + (min - 1);

		if (res.sum < this){res = res.add(num-res.sum); "sobro".postln};
		if (res.sum > this){res = res.put(res.size- 1, num- res.sum+ res[res.size- 1]);  "falto".postln};


}
	^res
}