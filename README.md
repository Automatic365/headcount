## Headcount

Project Overview

We'll build upon a dataset centered around schools in Colorado provided by the Annie E. Casey foundation. What can we learn about education across the state?

Starting with the CSV data we will:

- Build a "Data Access Layer" which allows us to query/search the underlying data
- Build a "Relationships Layer" which creates connections between related data
- Build an "Analysis Layer" which uses the data and relationships to draw conclusions


HEADCOUNT Original Spec: https://github.com/turingschool/curriculum/blob/master/source/projects/headcount.markdown

Pair Project: David Tinianow and Jason Hanna

Iterations 1-4 and 5 complete. All tests spec harness tests are passing. The output from rake sanitation:all shows zero complaints. The rake runs in about 6 seconds with zero errors, failures, or skips.

Learning Goals

Use tests to drive both the design and implementation of code
Decompose a large application into components such as parsers, repositories, and analysis tools
Use test fixtures instead of actual data when testing
Connect related objects together through references
Learn an agile approach to building software
