
remove-module PublishDacPac
Import-Module .\PublishDacPac -Force
New-MarkdownHelp -Module PublishDacPac -OutputFolder .\docs -Force -FwLink https://github.com/DrJohnT/PublishDacPac/docs
#-OnlineVersionUrl https://github.com/DrJohnT/PublishDacPac/
#-FwLink https://github.com/DrJohnT/PublishDacPac

# Update-MarkdownHelp .\docs

# New-ExternalHelp .\docs -OutputPath .\PublishDacPac\en-US\
