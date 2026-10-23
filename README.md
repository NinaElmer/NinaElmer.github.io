# Nina Elmer's website

A minimal academic website, hosted on GitHub Pages. The current site uses Jekyll;
the browser editor is configured in `.pages.yml` and can remain in place when
the site moves to Eleventy.

## Edit in your browser

After `.pages.yml` and the accompanying template changes are pushed to GitHub:

1. Open [Pages CMS](https://app.pagescms.org) and sign in with GitHub.
2. Install its GitHub App for **only this repository**,
   `NinaElmer/NinaElmer.github.io`.
3. Open the repository and choose `main` to edit the published site.
4. Choose a section, edit its fields and save.

The configuration is already provided; you do not need to create a new one.
Saving on `main` commits changes to GitHub and starts the existing GitHub Pages
publishing workflow. Publication takes place after that workflow succeeds.
Edits on another branch do not publish until merged into `main`.

This is a form-based content editor. It does not edit the page layout visually
or provide an exact preview of the finished website.

### About me and site heading

**About me** edits the introduction and research interests using a rich text
editor. **Site heading** edits your name, role, affiliation and homepage portrait. Layout fields and
hosting configuration are kept out of everyday editing.

### Publications

In **Publications**, add a paper title, author names, year and any PDF, DOI or arXiv links.
Keep papers in the order you want to display them, with newest first. The first
three appear on the homepage automatically; there is no separate featured list
to maintain.

Use full URLs for external links. For a locally hosted PDF, upload it in
**Publication PDFs**, then enter `/publications/filename.pdf` in the PDF link
field. Blank links are optional.

`_data/publications.yml` is the source used by the website and browser editor.
The original `_bibliography/publications.bib` and `scripts/generate_publications.rb`
remain available for manual imports. Running that script **replaces** the YAML
file, including edits made through the CMS, so do not run it as part of routine
browser editing. The publishing workflow does not run it automatically. Journal details and publication status can
also be edited here. Publication years refer to the journal citation where
available; the arXiv link retains the original preprint record. The old
`featured` key is retained for compatibility but is no longer used by the site.

### News

**News** edits the dated updates shown between the introduction and publications.
Add a date, short update and optional link. The homepage shows the five newest
entries automatically. The section starts empty, with a short placeholder, until
you add your first update.

### Talks

In **Talks**, open a year group or add a new one, then add a talk's title, event
and any additional information. Keep year groups and talks in display order,
newest first.

Upload slides in **Talk slides**, then enter `/talks/filename.pdf` in the talk's
link field. You can also paste an external URL, or leave the link blank for a
talk without slides.

### CV

Use **CV — academic experience** and **CV — education** for the displayed entries.
Each entry has a title, institution/dates and optional detail lines.

In **CV — PDF download**, use the file picker to upload or select the CV PDF.
If you upload a file with a new name, select it here so the download points to
the new file. Keep older PDFs when existing links still need to work.

### Teaching

**Teaching** edits the teaching page using a rich text editor. Add your teaching
experience, course descriptions and links to materials here. The page includes lectures, schools and training, tutorials, and supervision.

### Dark mode

The header's theme control uses a sun for Light, a moon for Dark and a monitor
for System. The selected icon is highlighted. System follows the
device's appearance and updates when it changes. A manual Light or Dark choice
is remembered on that browser; choosing System resets that override.

### Contact and photos

**Contact and social links** edits your contact details, photo and profile links.
Use the photo picker to select or upload an image. Each social link has a display
name such as GitHub, LinkedIn or Google Scholar, which appears in the footer.
Original icon settings are retained for compatibility with the theme.
Email links should start with `mailto:`.

Unexposed settings, including navigation, are preserved when saving. The media library contains the existing files;
deleting or renaming a file can break links already shared elsewhere.

## Local development

The Ruby dependencies are installed in the `webpage` Conda environment:

```sh
conda activate webpage
bundle exec jekyll serve --destination /private/tmp/nina-website-preview --disable-disk-cache
```

Open `http://localhost:4000`. The generated `_site` directory is build output;
edit the original content files instead.

To verify a build without starting the preview server:

```sh
conda run -n webpage bundle exec jekyll build --destination /private/tmp/nina-editor-verification --disable-disk-cache
```

On a fresh machine, install a compatible Ruby version (the GitHub workflow uses
Ruby 3.2) and run `bundle install` first.

## Folder guide

- Root Markdown files: your visible pages (`index.md`, `teaching.md`, etc.).
- `_data/`: news, publications, talks, CV entries and contact settings.
- `_layouts/` and `_includes/`: page structure and reusable sections.
- `assets/`: styles, theme controls, your photos, icons and Bootstrap.
- `publications/`, `talks/`, `cv/`: downloadable research files.
- `_bibliography/`: your BibTeX source for optional manual imports.
- `scripts/`: the optional publication import tool. Run it from the repository root:
  `bundle exec ruby scripts/generate_publications.rb`.
- `.pages.yml`: browser-editor configuration.
- `.github/`: automatic publishing workflow.

Generated output and local editor settings are excluded from Git. Commit the
cleanup's file removals along with the other changes; use the preview command
above to keep generated files outside the source folder.

## Migration progress

- Browser editor configuration: prepared locally; needs a push and GitHub App connection.
- Jekyll to Eleventy: not migrated yet.
- Design: refined with a portrait, clearer typography, separate publication titles and labelled social links.
- Existing URLs and GitHub Pages hosting: retained.
- Removed unused theme examples, stock images, caches and generated output.
- Build output and local editor settings are ignored by Git.

The next stage is to migrate the build to Eleventy, compare the generated pages
and existing links, and update the publishing workflow. This avoids mixing a
content-editor rollout with a change to the site builder.

## Theme credit

Based on [Academic by Paul Le](https://github.com/LeNPaul/academic), under the
MIT license. See `LICENSE.txt`.
