## Contributing
This document lays out exactly how you can contribute to BEMSimpleLineGraph. All contributions are welcome and appreciated. Thanks for contributing!

### Questions
The best way to ask questions is through [StackOverflow](http://www.stackoverflow.com) using the [BEMSimpleLineGraph tag](http://stackoverflow.com/questions/tagged/bemsimplelinegraph). StackOverflow questions are highly discoverable, viewed by an active and massive community of programmers, and incredibly reapplicable. If another developer using BEMSimpleLineGraph runs into the same question, it is to their advantage to find it on StackOverflow rather than via GitHub issues.

We would like to keep GitHub issues strictly for bugs, feature requests, enhancements, etc. You can [ask your question right here](http://stackoverflow.com/questions/ask). Make sure to add the correct tags.

### Issues (Bugs, Enhancements, Features)
The best way to report **issues** (e.g. bugs, glitches, problems, etc.) and **feature requests** (e.g. improvements, new features, API changes, etc.) with BEMSimpleLineGraph is by submitting an issue.

Submitting an issue on GitHub help us easily organize, track, manage, and respond to those issues. 

1. Open the BEMSimpleLineGraph project page on GitHub.  
2. Look through the [issues](https://github.com/Boris-Em/BEMSimpleLineGraph/issues) (opened or closed) for BEMSimpleLineGraph to see if your issue has already been fixed, answered, or is being fixed.  
3. Try filtering issues by "milestones" (i.e. updates / releases) using the milestone selector on the left side of the page.  
4. Create a [new issue](https://github.com/Boris-Em/BEMSimpleLineGraph/issues/new) using the button on the right side of the screen. Here are a few basic guidelines for writing an issue that make things easier on everyone:  
	1. One issue per issue. If you have more than one issue, bug to report, feature to request, or question to ask - open a separate issue for each. Don't make a list of issues inside of a single issue. It makes it easier to track and manage things when they're separated out.  
	2. Spell correctly; use proper punctuation and grammar. This may seem obvious, however, whn u spell not rite hard 2 reed. This helps minimize questions like: "Could you please clarify that?".  
	3. Use code blocks (hint: don't take a screenshot of your code). Not sure how to write markdown syntax for code? Take a look at [this wonderful guide](https://help.github.com/articles/markdown-basics#code-formatting) from the great people at GitHub.  

### Changes (Bug Fixes, Improvements, New Features)
The best way to contribute changes (e.g. a great idea, a new feature, bug fixes, etc.) to the project is through forks and pull requests. 

1. Fork this repository and clone that fork onto your computer.  
2. Make changes to the forked repo, fix any errors, debug.  
3. Commit and then push all the changes up to your forked GitHub repo.  
4. Submit a pull request from your forked GitHub repo into the main repo. Make sure to detail what changes you made in the pull request.  

#### Code Guidelines
Before submitting any code changes, read over the code / syntax guidelines to make sure everything you write matches the appropriate coding style. The [Objective-C Coding Guidelines](https://github.com/github/objective-c-conventions) are available on GitHub.

#### Documentation Guidelines
Document the changes you make. Only fundamental documentation is written in the `Readme.md` (e.g. setup, installation, data source, and delegation). Full documentation is written on the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki). There's a lot of work left to do on the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki), and any help **writing documentation for the wiki is greatly appreciated**.

API documentation is available in both the wiki and in Xcode (by option-clicking, using the Quick Help menu, or by going through the header files. See below for how to write documentation comments in the code.

Write appropriate documentation in the code (using comments). Always write the documentation comments in the header, above the related method, property, etc. Write regular comments with your code in the implementation too. Here's an example of a documentation comment:

    /// One line documentation comments can use the triple forward slash
    @property (strong) NSObject *object;

    /** Multi-line documentation comments can use the forward slash with a double asterisk at the beginning and a single asterisk at the end.
        @description Use different keys inside of a multi-line documentation comment to specify various aspects of a method. There are many available keys that Xcode recognizes: @description, @param, @return, @deprecated, @warning, etc. The documentation system also recognizes standard markdown formatting within comments. When building the documentation, this information will be appropriately formatted in Xcode and the Document Browser.
        
        @see Use this key to add a see-also section.
        
        @todo Still have more to add later, something left to do in the implementation? Use this key.

        @param parameterName Parameter Description. The @param key should be used for each parameter in a method. Make sure to describe exactly what the parameter does and if it can be nil or not.
        @return Return value. Use the @return key to specify a return value of a method. */
    - (BOOL)alwaysWriteDocumentCommentsAboveMethods:(NSObject *)paramName;

## What to Contribute
Contribute anything, we're open to ideas! Although if you're looking for a little more structure, you can go through the [open issues on GitHub](https://github.com/Boris-Em/BEMSimpleLineGraph/issues?state=open) or look at the known issues in the [Releases documentation](https://github.com/Boris-Em/BEMSimpleLineGraph/releases). Additionally, a lot of documentation needs to be written on the [wiki](https://github.com/Boris-Em/BEMSimpleLineGraph/wiki) (and contributions there are greatly appreciated).
