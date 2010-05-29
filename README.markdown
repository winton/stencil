Stencil
=======

Project template manager.

Requirements
------------

<pre>
sudo gem install stencil
</pre>

Setup the template
------------------

You only have to do this once.

<pre>
git clone git@github.com:winton/gem_template.git
cd gem_template
stencil
</pre>

Setup a new project
-------------------

Do this for every new project.

<pre>
mkdir my_project
cd my_project
git init
stencil gem_template [BRANCH, BRANCH, ...]
rake rename
</pre>

The last command does a find-replace (gem\_template -> my\_project) on files and filenames.

Commit from project to template
-------------------------------

<pre>
stencil ^ [COMMIT HASH]
</pre>
