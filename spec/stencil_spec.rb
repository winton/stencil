require 'spec_helper'

describe Stencil do
  before :all do
    @fixture = "#{$root}/spec/fixture"
    
    FileUtils.rm_rf(@fixture)
    FileUtils.mkdir_p(@fixture)

    Dir.chdir(@fixture)
    FileUtils.touch("master.txt")
    
    `git init .`
    `git add .`
    `git commit -a -m "master"`

    @branches = %w(
      a
      a-a
      a-b
      b
      b-a
      b-a-c
    )

    @branches.each do |branch|
      `git branch #{branch}`
    end

    @branches.each do |branch|
      `git checkout #{branch}`

      FileUtils.touch("#{branch}.txt")

      `git add .`
      `git commit -m "#{branch}"`
    end

    Stencil::Branches.read(@fixture) # warm up @@branches cache
  end

  describe :initialize do
    before :all do
      @cmds = [
        "git fetch --all",
        "git checkout master",
        "git pull origin master",
        "git checkout a",
        "git merge master",
        "git push origin a",
        "git checkout a",
        "git pull origin a",
        "git checkout a-a",
        "git merge a",
        "git push origin a-a",
        "git checkout a-b",
        "git merge a",
        "git push origin a-b",
        "git checkout b",
        "git merge master",
        "git push origin b",
        "git checkout b",
        "git pull origin b",
        "git checkout b-a",
        "git merge b",
        "git push origin b-a",
        "git checkout b-a",
        "git pull origin b-a",
        "git checkout b-a-c",
        "git merge b-a",
        "git push origin b-a-c",
        "git checkout master"
      ]
    end

    it "should execute correct commands" do
      @cmds.each do |cmd|
        if cmd == "git branch"
          Stencil::Cmd.should_receive(:run).with(@fixture, cmd).ordered.and_call_original
        else
          Stencil::Cmd.should_receive(:run).with(@fixture, cmd).ordered
        end
      end
      Stencil.new([ "push" ])
    end

    it "should merge properly" do
      @cmds.each do |cmd|
        if cmd.include?('push') || cmd.include?('pull')
          Stencil::Cmd.should_receive(:run).with(@fixture, cmd).ordered
        else
          Stencil::Cmd.should_receive(:run).with(@fixture, cmd).ordered.and_call_original
        end
      end
      Stencil.new([ "push" ])
      # TODO: check merge happened
    end

    it "should exit on merge conflict" do
      @cmds[0..@cmds.index("git push origin a")-1].each do |cmd|
        if cmd.include?('push') || cmd.include?('pull')
          Stencil::Cmd.should_receive(:run).with(@fixture, cmd).ordered
        else
          Stencil::Cmd.should_receive(:run).with(@fixture, cmd).ordered.and_call_original
        end
      end

      `git checkout master`
      File.open("#{@fixture}/master.txt", 'w') do |f|
        f.write("conflict")
      end
      `git commit -a -m "master conflict"`

      `git checkout a`
      File.open("#{@fixture}/master.txt", 'w') do |f|
        f.write("conflict2")
      end
      `git commit -a -m "a conflict"`

      lambda { Stencil.new([ "push" ]) }.should raise_error SystemExit
    end
  end

  describe Stencil::Branches do
    it "should return branch names" do
      Stencil::Branches.read(@fixture).should == @branches + [ 'master' ]
    end

    it "should return grouped branch names" do
      Stencil::Branches.grouped(@fixture).should == {
        "master" => {
          "a" => {
            "a" => {},
            "b" => {}
          },
          "b" => {
            "a" => {
              "c" => {}
            }
          }
        }
      }
    end
  end
end