
proc lastChar {line} {
	return [string index $line [expr [string length $line] - 1]]
}

proc trimLast {line} {
	return [string range $line 0 [expr [string length $line] - 2]]
}
