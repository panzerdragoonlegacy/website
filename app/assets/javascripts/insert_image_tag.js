function transformTextIntoList(text, ordened) {
    if (typeof ordened == "undefined") {
        ordened = false;
    }
    var lines = textToLines(text);
    var list = "";
    if (lines == null) {
        if (ordened) {
            list = "1. ";
        }
        else {
            list = "- ";
        }
    }
    else {
        for (var i = 0; i < lines.length; i++) {
            if (ordened) {
                list += (i + 1) + ". " + lines[i] + "\n";
            }
            else {
                list += "- " + lines[i] + "\n";
            }
        }
    }
	return list;
}

function transformTextIntoOrdenedList(text) {
    return transformTextIntoList(text, true);
}

function transformTextIntoDescriptions(text)
{
	var lines = textToLines(text);
	var list= "";
	for (var i = 0; i < lines.length; i++) {
		list += ": " + lines[i] + "\n";
	}
	return list;
}

function textToLines(text)
{
	return text.match(/^.+$/gm);	
}

function resetModalWindow() {
    $(this).dialog("close");
    $("#modalInput1").val("");
    $("#modalLabel1").text("");
    $("#modalInput2").val("");
    $("#modalLabel2").text("");
    $("#modalInput3").val("");
    $("#modalLabel3").text("");
    $("#modalInput4").val("");
    $("#modalLabel4").text("");
    $("#modalRow1").show();
    $("#modalRow2").show();
    $("#modalRow3").show();
    $("#modalRow4").show();
    $("#modalWindow").dialog("close");
}

function selectionContainer() {
    this.selection = "";
    this.bookmark = null;
}

$(document).ready(function () { // Wait until page is ready rendering the page

    $("#modalWindow").dialog({
        autoOpen: false,
        resizable: false,
        draggable: false,
        modal: true,
        width: '20%'
    });

    jQuery.fn.extend({
        getSelectedTextInTextArea: function () {
            var container = new selectionContainer();
            this.each(function (i) {
                if (document.selection) {
                    this.focus(); // this is needed or the cursor position won't be remember when no text is selected
                    var range = document.selection.createRange();
                    container.selection += range.text;
                    container.bookmark = range.getBookmark();
                }
                else if (this.selectionStart || this.selectionStart == '0') {
                    container.selection += this.value.substring(this.selectionStart, this.selectionEnd);
                }
            })
            return container;
        }
    });

    jQuery.fn.extend({
        insertTextInTextArea: function (replacementText, openTag, closeTag, transformFunction, appendText, bookmark) {
            return this.each(function (i) {
                if (document.selection) {
                    this.focus();
                    sel = document.selection.createRange();

                    if (typeof bookmark != "undefined" && bookmark != null) {
                        sel.moveToBookmark(bookmark); // seems to perform a collapse(false) to set the start and end positions to the end of the selection?
                        sel.moveStart("character", -length);
                    }

                    var content = (replacementText.length > 0 ? replacementText : sel.text);
                    if (transformFunction != null) {
                        content = transformFunction(content);
                    }

                    sel.text = openTag + content + closeTag;
                    var length = (openTag + content + closeTag).length; // sel.text.length doesn't return the correct value, so store it in separate value;


                    if (closeTag != "") {
                        sel.moveEnd("character", -closeTag.length); // move end of selection so that the selection doesn't include the end tag
                    }
                    if (openTag != "") {
                        sel.moveStart("character", -content.length); // move start of selection from the end point back to the start of the content (excluding the start tag)
                    }

                    if (closeTag == "" && openTag == "") { // needed to set the selected text positions when no tags were used... 
                        sel.moveStart("character", -length);
                    }
                    sel.select();

                    if (typeof appendText != "undefined" && appendText != null && appendText.length > 0) {
                        //$(this).focus(); // not sure if needed
                        range = document.selection.createRange();

                        // retrieve the start and end position for IE...
                        var duplicateRange = range.duplicate();
                        duplicateRange.moveToElementText(this); // make a selection that contains all the text in the textarea
                        duplicateRange.setEndPoint("EndToEnd", range); // move the end of the duplicate range to the end of the other range (the starting position for the duplicate is still at the start of the textarea)
                        var startPos = duplicateRange.text.length - range.text.length; // this gives us the number of characters between the start of the textarea and the end position of the selected text
                        var endPos = range.text.length; // this gives us the ending position relative to the starting position (so this is equivalent to the length of the selection)

                        this.value += appendText; // currently this removes the selection, se we need to set the selection again, using the start and end position
                        var test = document.selection.createRange();
                        test.collapse(true); // reset start and end position to the start of the textarea
                        test.moveStart("character", startPos);
                        test.moveEnd("character", endPos);
                        test.select(); // select the text between start and end position
                    }
                }
                else if (this.selectionStart || this.selectionStart == '0') {
                    var startPos = this.selectionStart;
                    var endPos = this.selectionEnd;
                    var scrollTop = this.scrollTop;
                    var content = (replacementText.length > 0 ? replacementText : this.value.substring(startPos, endPos));
                    if (transformFunction != null) {
                        content = transformFunction(content);
                    }
                    content = openTag + content + closeTag;
                    this.value = this.value.substring(0, startPos) + content + this.value.substring(endPos, this.value.length);
                    this.focus();
                    if (typeof appendText != "undefined" && appendText != null && appendText.length > 0) {
                        this.value += appendText;
                    }
                    this.selectionStart = startPos + openTag.length;
                    this.selectionEnd = startPos + content.length - closeTag.length;
                    this.scrollTop = scrollTop;
                } else {
                    this.value += content + appendText;
                    this.focus();
                }
            })
        }
    });

    // Search all elements with css class = "insert_tag" and add an inline function to their click event.
    $("#btnInsertLists").click(function (event) {
        $('.data_entry').insertTextInTextArea("", "", "", transformTextIntoList);
        event.preventDefault();
    });

    $("#btnInsertOrdenedLists").click(function (event) {
        $('.data_entry').insertTextInTextArea("", "", "", transformTextIntoOrdenedList);
        event.preventDefault();
    });

    $("#btnInsertTitle").click(function (event) {
        $('.data_entry').insertTextInTextArea("", "<cite>", "</cite>", null);
        event.preventDefault();
    });

    $("#btnInsertHyperlink").click(function (event) {
        var selectedContainer = $('.data_entry').getSelectedTextInTextArea();
        $("#modalRow2").hide();
        $("#modalRow4").hide();
        $("#modalLabel1").text('Text:');
        if (selectedContainer.selection.length > 0) {
            $("#modalInput1").val($.trim(selectedContainer.selection));
        }
        $("#modalLabel3").text('Hyperlink:');
        $("#modalWindow").dialog("option", "title", "Enter hyperlink:");
        $("#modalWindow").dialog("option", "buttons", [
			{
			    text: 'Ok',
			    click: function () {
			        var content = "[" + $("#modalInput1").val() + "](" + $("#modalInput3").val() + ")";
			        $('.data_entry').insertTextInTextArea(content, "", "", null, "", selectedContainer.bookmark);
			        resetModalWindow();
			    }
			},
			{
			    text: 'Cancel',
			    click: function () {
			        resetModalWindow();
			    }
			}]
		);
        $("#modalWindow").dialog("open");
        event.preventDefault();
    });

    $("#btnInsertEmphasis").click(function (event) {
        $('.data_entry').insertTextInTextArea("", "*", "*", null);
        event.preventDefault();
    });

    $("#btnInsertStrongEmphasis").click(function (event) {
        $('.data_entry').insertTextInTextArea("", "**", "**", null);
        event.preventDefault();
    });

    $("#btnInsertFootnote").click(function (event) {
        var selectedContainer = $('.data_entry').getSelectedTextInTextArea();
        $("#modalRow2").hide();
        $("#modalRow3").hide();
        $("#modalLabel1").text('Name:');
        if (selectedContainer.selection.length > 0) {
            $("#modalInput1").val($.trim(selectedContainer.selection));
        }
        $("#modalLabel4").text('Content:');
        $("#modalWindow").dialog("option", "width", "20%");
        $("#modalWindow").dialog("option", "title", "Enter footnote:");
        $("#modalWindow").dialog("option", "buttons", [
			{
			    text: 'Ok',
			    click: function () {
			        var footNoteLink = "[^" + $("#modalInput1").val() + "]";
			        var footNoteContent = "\n\n" + footNoteLink + ": " + $("#modalInput4").val();
			        $('.data_entry').insertTextInTextArea(footNoteLink, "", "", null, footNoteContent, selectedContainer.bookmark);
			        resetModalWindow();
			    }
			},
			{
			    text: 'Cancel',
			    click: function () {
			        resetModalWindow();
			    }
			}]
		);
        $("#modalWindow").dialog("open");
        event.preventDefault();
    });

    $("#btnInsertBlockQuote").click(function (event) {
        $('.data_entry').insertTextInTextArea("", "> ", "", null);
        event.preventDefault();
    });

    $("#btnInsertDataDefinition").click(function (event) {
        var selectedContainer = $('.data_entry').getSelectedTextInTextArea();
        $("#modalRow2").hide();
        $("#modalRow3").hide();
        $("#modalLabel1").text('Term:');
        if (selectedContainer.selection.length > 0) {
            $("#modalInput1").val($.trim(selectedContainer.selection));
        }
        $("#modalLabel4").text('Description:');
        $("#modalWindow").dialog("option", "title", "Enter term and description:");
        $("#modalWindow").dialog("option", "buttons", [
			{
			    text: 'Ok',
			    click: function () {
			        var content = $("#modalInput1").val() + "\n" + transformTextIntoDescriptions($("#modalInput4").val()) + "\n";
			        $('.data_entry').insertTextInTextArea(content, "", "", null, "", selectedContainer.bookmark);
			        resetModalWindow();
			    }
			},
			{
			    text: 'Cancel',
			    click: function () {
			        resetModalWindow();
			    }
			}]
		);
        $("#modalWindow").dialog("open");

        event.preventDefault();
    });

    $("#btnInsertCode").click(function (event) {
        $('.data_entry').insertTextInTextArea("", "`", "`", null);
        event.preventDefault();
    });

    $("#btnInsertSecondLevelHeading").click(function (event) {
        $('.data_entry').insertTextInTextArea("", "## ", "", null);
        event.preventDefault();
    });

    $("#btnInsertThirdLevelHeading").click(function (event) {
        $('.data_entry').insertTextInTextArea("", "### ", "", null);
        event.preventDefault();
    });

    $("#btnInsertManualImageTag").click(function (event) {
        try {
            var selectedContainer = $('.data_entry').getSelectedTextInTextArea();
            $("#modalRow2").hide();
            $("#modalRow4").hide();
            $("#modalLabel1").text('Description:');
            $("#modalLabel3").text('Filename:');
            if (selectedContainer.selection.length > 0) {
                $("#modalInput1").val($.trim(selectedContainer.selection));
            }
            $("#modalWindow").dialog("option", "title", "Enter filename:");
            $("#modalWindow").dialog("option", "buttons", [
			    {
			        text: 'Ok',
			        click: function () {
			            var content = "![" + $("#modalInput1").val() + "](" + $("#modalInput3").val() + ")";
			            $('.data_entry').insertTextInTextArea(content, "", "", null, "", selectedContainer.bookmark);
			            resetModalWindow();
			        }
			    },
			    {
			        text: 'Cancel',
			        click: function () {
			            resetModalWindow();
			        }
			    }]
		    );
            $("#modalWindow").dialog("open");
        }
        catch (err) {
            alert(err.Description);
        }
        event.preventDefault();
    });


    $("#btnInsertHorizontalRule").click(function (event) {
        $('.data_entry').insertTextInTextArea("\n* * *\n", "", "", null);
        event.preventDefault();
    });


    $(".insert_tag").click(function (event) {
        // Get parent element and then get its child elements of type "img" to retrieve their image text 
        // this makes sure we get the image element that resides in the same parent div of the button we clicked.
        var imageText = $(this).parent().children("img").attr('src').split('/').pop();

        // Removes question mark and numbers from after the .jpg. 
        imageText = imageText.substring(0, imageText.indexOf("jpg") + "jpg".length);

        // Removes "jpg" from the end of the caption and captialise the first character. 
        captionText = imageText.replace(/-/g, " ").replace("jpg", "");
        captionText = captionText.charAt(0).toUpperCase() + captionText.slice(1);

        // Call the custom insertAtCaret function on the element with id = "article_content".
        $('.data_entry').insertTextInTextArea("![" + captionText + "](" + imageText + ")", "", "", null);

        // Prevents the button from actually submitting the form like it normally would.
        event.preventDefault();
    });
});