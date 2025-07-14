﻿# How to format results https://devblogs.microsoft.com/scripting/psscriptanalyzer-deep-dive-part-3-of-4/

# Install module using: 
# Install-Module -Name PSScriptAnalyzer -Force

#region PSScriptAnalyzer Testing
Describe 'Checking scripts against PSScriptAnalyzer rules' -Tag "Round1" {
    Context 'PSScriptAnalyzer Standard Rules' {
		Import-Module PSScriptAnalyzer;

		$CurrentFolder = Split-Path -Parent $PSScriptRoot;
		$PublicPath = Resolve-Path "$CurrentFolder\PublishDacPac\public\";

        $ExcludeRules = @('PSUseSingularNouns','PSUseDeclaredVarsMoreThanAssignments');

		$includeScripts = Get-ChildItem "$PublicPath" -Recurse -Include *.ps1 -Exclude *Tests.ps1;

	    foreach ($script in $includeScripts) {
			[string]$scriptPath = $script.FullName;

		    Write-host "Analysing $scriptPath";

            $AnalyzerIssues = Invoke-ScriptAnalyzer -Path $scriptPath;

	        $ScriptAnalyzerRuleNames = Get-ScriptAnalyzerRule | Select-Object -ExpandProperty RuleName;

			#ExcludeRule parameter/SuppressRule attribute/Profile;
	        forEach ($Rule in $ScriptAnalyzerRuleNames)
	        {
		        if ($ExcludeRules -notcontains $Rule)
		        {
			        It "Should pass $Rule" {
				        $Failures = $AnalyzerIssues | Where-Object -Property RuleName -EQ -Value $rule
				        ($Failures | Measure-Object).Count | Should -Be 0
			        }
		        }
<#
				else
		        {
			        # We still want it in the tests, but since it doesn't actually get tested we will skip
			        It "Should pass $Rule" -Skip {
				        $Failures = $AnalyzerIssues | Where-Object -Property RuleName -EQ -Value $rule
				        ($Failures | Measure-Object).Count | Should -Be 0
			        }
		        }
#>
	        }
	    }

    }

}
#endregion