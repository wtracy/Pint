#!/usr/bin/tclsh

# {proc name {args} {vars}} | {call name {args}} 
# | {set name value}
# | {while guard {body}} 
# | {if guard {body} [{else}]}
# | {return value} | {expr ?}
# | {gets ?}?
# | break

proc lastChar {line} {
	return [string index $line [expr [string length $line] - 1]]
}

proc trimLast {line} {
	return [string range $line 0 [expr [string length $line] - 2]]
}

proc parseStatement {statement} {
	puts $statement
}

proc parseLine {line} {
	#parseStatement $line
	puts "Parsing line: $line"
	#foreach i $line {
	#	puts $i
	#}
}

proc balanceBraces {line} {
	set balance 0
	set quoted false
	for {set i 0} {$i < [string length $line]} {incr i} {
		set character [string index $line $i]
		set isOpenBrace [string equal $character "{"]
		set isCloseBrace [string equal $character "}"]
		#puts "Is this a brace? $character"
		if {[string equal $character "\""]} {
			set quoted [expr ! $quoted]
		}
		if { $isOpenBrace } {
			incr balance
		} elseif {$isCloseBrace} {
			incr balance -1
		}
		#puts "Calculating braces balance: $balance"
	}
	#puts "Balance computed at $balance"
	return $balance
}

proc readSource {source} {
	set f [open $source]
	while {[gets $f line] >= 0} {
		set line [string trim $line]
		set last [lastChar $line]
		if {[string equal [string index $line 0] "#"]} {
			puts "Comment."
		} else {
			set escapedNewline [string equal $last "\\"]
			set bracesBalance [balanceBraces $line]
			set bracesUnBalanced [expr $bracesBalance != 0]

			while {$escapedNewline \
				|| $bracesUnBalanced } \
			{
				#puts "Checking for completenes: $line"
				#if {$escapedNewline} {puts "Escaped line ending!"}
				#if {$bracesUnBalanced} {puts "Unbalanced braces: $bracesBalance"}
				if {[eof $f]} {
					puts "Input terminated unexpectedly!"
					return;
				}
				gets $f append
				set append [string trim $append]
				if {$escapedNewline} \
				{
					set trimmed [trimLast $line]
					set line $trimmed$append
				} else {
					set line "$line;$append"
				}
				set last [lastChar $line]
				set bracesBalance [balanceBraces $line]
				set bracesUnBalanced [expr $bracesBalance != 0]
			}
			parseLine $line
		}
	}
	close $f
}

if { $argc != 1 } {
	puts "Bad arguments. Try again!"
	exit
} else {
	readSource [lindex $argv 0]
}


