# what if there was a language that was all keywords and no operators?
# yea yea it's not aware of the ast, i'm just doing a bit 

#figure out how to get something more granular than unicodecategory...

# mocking this as i find a stanard character description library...
$charmap = @{

}
# $charList = [PSCustomObject]@(
# 	@{
# 		character   = "{"
# 		replacement = "leftBracket"
# 	},
# 	@{
# 		character   = "}"
# 		replacement = "rightBracket"
# 	}
# )


$specials =
@"
"!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~"
"@ -split ""

$specials = 
$charList = [PSCustomObject](
	$specials | ForEach-Object { 
		@{
			character   = $_
			replacement = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory([char]$_)
		}
	}
)
function replace { 
	param(
		$content,
		$a,
		$b
	)
	$update = $content
	$charList | Foreach-Object { 
		$update = $update.Replace($_["$a"], ("" + $_["$b"] + ""))
	}
	$update
}
function check { 

}
function decompile { 
	param(
		[Parameter(ValueFromPipeline = $true)]
		$file
	)
	
	# $content | Set-Content $file
	$content = (Get-Content $file)  
	$output = replace -content $content "character" "replacement" 
	Set-Content -Force -Path "$file.out" -Value $output
	
}


function compile { 
	param(
		[Parameter(ValueFromPipeline = $true)]
		$file
	)
	$content = Get-Content $file 
	$output = replace $content "replacement" "character"
	Set-Content -Force -Path "$file.in" -Value $output
}
"doit.ps1" | decompile 
"doit.ps1.out" | compile