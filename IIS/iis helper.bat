:: Description:
::    Solve some common trouble spots for iis.
:: Script tested in:
::    Windows Server 2012 Datacenter x64
:: Author:
::    serveryang@qq.com

chcp 65001

REM 1) Register locally installed .net Frameworks in IIS.

  C:\Windows\Microsoft.NET\Framework\v2.0.50727\aspnet_regiis.exe -i
  C:\Windows\Microsoft.NET\Framework\v4.0.30319\aspnet_regiis.exe -i

REM 2) Install IIS support WCF features, solve the IIS cannot support. SVC format.

  dism /Online /Enable-Feature /FeatureName:WAS-WindowsActivationService
  dism /Online /Enable-Feature /FeatureName:WAS-ProcessModel
  dism /Online /Enable-Feature /FeatureName:WAS-NetFxEnvironment
  dism /Online /Enable-Feature /FeatureName:WAS-ConfigurationAPI
  dism /Online /Enable-Feature /FeatureName:WCF-HTTP-Activation
  dism /Online /Enable-Feature /FeatureName:WCF-HTTP-Activation45

REM Installation complete!

pause
