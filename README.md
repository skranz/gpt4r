# gpt4rstudio

## 1. Main Idea

The package creates RStudio Addins that help using Chat-GPT. These Addins can perform operations on selected text in your active document and insert the results in the same document or a new one. The package comes with 3 addins aimed to improve text (`GPT rewrite` and `GPT suggest`) or to improve, comment or translate to R code (`GPT code`). 

The key feature of gpt4rstudio is that you can customize Addins by editing YAML templates that specify the ChatGPT prompt and how results are presented in RStudio. Advanced users can build their R package that specifies Addins based on 'gpt4rstudio' functionality.

The Chat-GPT interaction is logged in a local folder by default. This feature could be useful for students who need to account for Chat-GPT usage in a thesis.

## 2. Installation

Via r-universe:

## 3. Alternative use: Just copy prompts for ChatGPT

If you don't want yet to use an OpenAI API key (see below), you can use the package to copy prompts to the clipboard that you can then manually paste in ChatGPT's (or Bing Chat's) web interface.

To do so set it is as the default option by calling

```r
set_gpt_default_action("copy_prompt")
```

To revert to the default, i.e. running OpenAI's API, call:

```r
set_gpt_default_action("run")
```

## 4. OpenAI API Key

To properly use the package, you should set up your OpenAI API key in R.

1. You need to [sign-up to OpenAI](https://platform.openai.com/signup). You probably can first test the API for a limited time and volume free of charge.

2. Then you must generate an API Key under your account setting. See also [Best Practices for API Key
Safety](https://help.openai.com/en/articles/5112595-best-practices-for-api-key-safety).

3. Then you have to assign your API key for usage in R, this can be done
just for the actual session, by doing:

``` r
Sys.setenv(OPENAI_API_KEY = "XX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
```

Or you can create a text file `openai.key` containing just the key as string in the directory of the documents that you modify. If `gpt4rstudio` finds such a text file, it loads the key from it. 
