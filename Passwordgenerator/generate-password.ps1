
$chars = @('!','@','$','%','^','&','*','?',';',':')
$threeletterwords = get-content .\3letter.txt
$fourletterwords = get-content .\4letter.txt
$fiveletterwords = get-content .\5letter.txt

# choose one of three combos: 3 & 5, 5 & 3, 4 & 4 => 8 letters
# replace one char of one word with a char and one char of the other word with a number
# capitalise one letter of one word

function obscure-word ($word, $salt, $pepper) {
    $array = $word.ToCharArray()
    $char = get-random -maximum ($array.count - 1)
    if ($pepper) {
	$upperchar = get-random -maximum $array.count
	if ($upperchar -eq $char) { $upperchar += 1 }
	$array[$upperchar] = $array[$upperchar].tostring().toupper()
    }    
    $array[$char] = "$salt"
    [string]::join("",$array)
}

function get-password {
    $orderlist = get-random -maximum 3
    switch ($orderlist) {
	0 {
	    # a 3 letter word followed by 5 letter - put the pepper in the second word
	    $index1 = get-random -maximum ( $threeletterwords.count + 1 ) 
	    $index2 = get-random -maximum ( $fiveletterwords.count + 1 ) 
	    $first = obscure-word $threeletterwords[$index1] $digit
	    $second = obscure-word $fiveletterwords[$index2]  $chars[$digit] $true
	}
	1 {
	    # a 5 letter word followed by 3 letter - put the pepper in the first word
	    $index1 = get-random -maximum ( $fiveletterwords.count + 1 )
	    $index2 = get-random -maximum ( $threeletterwords.count + 1 ) 
	    $first = obscure-word $fiveletterwords[$index1]  $chars[$digit] $true
	    $second = obscure-word $threeletterwords[$index2]  $digit.tostring() 
	}
	2 {
	    #two four letter words - randomise the pepper
	    $pepper = get-random -maximum 2 
    	    $index1 = get-random -maximum ( $fourletterwords.count + 1 )  
	    $index2 = get-random -maximum ( $fourletterwords.count + 1 )
	    if ($pepper -eq 0 ) { 
		$first = obscure-word $fourletterwords[$index1]  $digit.tostring() $false
		$second = obscure-word $fourletterwords[$index2]  $chars[$digit] $true
	    } else
	    { 
		$first = obscure-word $fourletterwords[$index1]   $chars[$digit] $true
		$second = obscure-word $fourletterwords[$index2] $digit.tostring() $false
	    }
	}
    }

    return "$first$second"
}

for ($i = 0 ; $i -lt 10; $i++ ) { 
    $digit = get-random -maximum 10 
    get-password 
}
