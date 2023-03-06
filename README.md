# gpt4r

Tools to easier use OpenAI's interface for ChatGPT from R.

This package is mainly used by the [mygpt package](https://github.com/skranz/mygpt) for customizable ChatGPT addins in RStudio. 

But you can also use it directly. Here is a short example:

```r
library(gpt4r)

prompt = "Below you find a task for a student, a sample solution and the answer by the student. Please evaluate the student's answer based on the sample solution.

TASK FOR STUDENT:

{{task}}

SAMPLE SOLUTION:

{{solution}}

STUDENT'S ANSWER:

{{answer}}
"


# Create template from prompt above and run it
tpl = new_gtp_tpl(prompt=prompt, temperature = 0.9)

# One example for the template
task = "Describe all information given about Germany in the tex we read in our lecture."

solution = "It is a founding member of the EU since 1958. Its population is roughly 80 million. Longest chancellor after the 2nd world war was Helmut Kohl (16 years), longest chancellor overall was Bismarck (22 years)"

answer = "Germany is the biggest country in Europe and member of the EU. Chancellor for the longest time was Helmut Kohl."

values = list(task=task, solution=solution, answer=answer)

# Set OpenAI API key and run the template  

Sys.setenv(OPENAI_API_KEY = "XX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
res = run_gpt_with_tpl(tpl, values)

# The output
res$output

# Alternative: just generate prompt and copy to clipboard
# Can be used in web interface of ChatGPT or BingGPT

get_gpt_prompt(tpl, values, to_clipboard=TRUE)

# Currently (2023-03-6) BingChat provides a much better result for this task
# than the ChatGPT API.
# But thinks will probably change.

```


## Installation

Via r-universe:


## 4. OpenAI API Key

To directly use the OpenAI API you have to set up your OpenAI API key in R.

1. You need to [sign-up to OpenAI](https://platform.openai.com/signup). You probably can first test the API for a limited time and volume free of charge.

2. Then you must generate an API Key under your account setting. See also [Best Practices for API Key
Safety](https://help.openai.com/en/articles/5112595-best-practices-for-api-key-safety).

3. Then you have to assign your API key for usage in R, this can be done
just for the actual session, by doing:

``` r
Sys.setenv(OPENAI_API_KEY = "XX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
```

Or you can create a text file `openai.key` containing just the key as string in the directory of the documents that you modify. If `gpt4rstudio` finds such a text file, it loads the key from it. 
