require "shelljs/global"

defaults = 
  nuget_exe: "tools/nuget/NuGet.exe"
  task: "restore"
  args: "src/AirPlans.sln"

module.exports = (grunt) ->
	grunt.registerTask "nuget", "Nuget command line implementation", () ->
    options = this.options(defaults)
    monoPrefix = if process.platform in ["linux", "darwin"] then "mono " else ""
    exec "#{monoPrefix} #{options.nuget_exe} #{options.task} #{options.args}"
    return
  return




