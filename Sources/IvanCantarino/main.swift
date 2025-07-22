import Foundation
import Publish
import Plot
import SplashPublishPlugin

struct IvanCantarino: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any custom metadata here
    }

    var url: URL {
        // Check if we're running in CI (production) or locally
        if ProcessInfo.processInfo.environment["CI"] == "true" {
            return URL(string: "https://www.ivancantarino.com")!
        } else {
            return URL(string: "http://localhost:8080")!
        }
    }
    var name = "Ivan Cantarino"
    var description = "Personal website and blog"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

extension Theme where Site == IvanCantarino {
    static var customFoundation: Self {
        Theme(htmlFactory: FoundationHTMLFactory())
    }
}

struct FoundationHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(.text(index.title)),
                    .p(.class("description"), .text(context.site.description)),
                    .h2("Latest content"),
                    .itemList(for: context.allItems(sortedBy: \.date, order: .descending), on: context.site)
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makeSectionHTML(for section: Section<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .header(for: context, selectedSection: section.id),
                .wrapper(
                    .h1(.text(section.title)),
                    .itemList(for: section.items, on: context.site)
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makeItemHTML(for item: Item<Site>, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(.class("item-page"),
                .header(for: context, selectedSection: item.sectionID),
                .wrapper(
                    .article(
                        .div(.class("content"), .contentBody(item.body)),
                        .span("Tagged with: "),
                        .tagList(for: item, on: context.site)
                    ),
                    .commentsSection(for: item, on: context.site)
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(.contentBody(page.body)),
                .footer(for: context.site)
            )
        )
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1("Browse all tags"),
                    .ul(
                        .class("all-tags"),
                        .forEach(page.tags.sorted()) { tag in
                            .li(
                                .class("tag"),
                                .a(
                                    .href(context.site.path(for: tag)),
                                    .text(tag.string)
                                )
                            )
                        }
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(
                        "Tagged with ",
                        .span(.class("tag"), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .nav(
                    .ul(
                        .forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        },
                        .li(.a(
                            .href("/about"),
                            .text("About Me")
                        ))
                    )
                )
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .p(
                .text("Copyright © Ivan Cantarino, 2025")                          
            ),
            .p(.a(
                .text("RSS feed"),
                .href("/feed.rss")
            ))
        )
    }

    static func commentsSection<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .div(.class("comments-section"),
            .h2("Comments"),
            .div(.id("giscus-comments")),
            .script(.src("https://giscus.app/client.js"),
                .attribute(named: "data-repo", value: "ivancantarino/publish-ivan-cantarino"),
                .attribute(named: "data-repo-id", value: "R_kgDOPQa3AQ"),
                .attribute(named: "data-category", value: "General"),
                .attribute(named: "data-category-id", value: "DIC_kwDOPQa3Ac4CtSeS"),
                .attribute(named: "data-mapping", value: "pathname"),
                .attribute(named: "data-strict", value: "0"),
                .attribute(named: "data-reactions-enabled", value: "1"),
                .attribute(named: "data-emit-metadata", value: "1"),
                .attribute(named: "data-input-position", value: "bottom"),
                .attribute(named: "data-theme", value: "dark_dimmed"),
                .attribute(named: "data-lang", value: "en"),
                .attribute(named: "crossorigin", value: "anonymous"),
                .attribute(named: "async", value: "")
            )
        )
    }
}

private extension Node where Context == HTML.DocumentContext {
    static func head<T: Website>(for location: Location, on site: T) -> Node {
        let title = location.title.isEmpty ? site.name : "\(location.title) | \(site.name)"
        let description = location.description.isEmpty ? site.description : location.description
        let isLocalhost = site.url.absoluteString.contains("localhost")

        return .head(
            .encoding(.utf8),
            .siteName(site.name),
            .url(site.url(for: location)),
            .title(title),
            .description(description),
            .twitterCardType(location.imagePath == nil ? .summary : .summaryLargeImage),
            .unwrap(location.imagePath ?? site.imagePath) { path in
                .socialImageLink(site.url(for: path))
            },
            .viewport(.accordingToDevice),
            .link(.rel(.shortcutIcon), .href("/images/favicon.png"), .type("image/png")),
            .link(.rel(.stylesheet), .href(isLocalhost ? "/styles.css?v=5" : "/styles.css"), .type("text/css")),
            .link(.rel(.stylesheet), .href(isLocalhost ? "/custom.css?v=7" : "/custom.css"), .type("text/css")),
            .link(.rel(.alternate), .href("/feed.rss"), .type("application/rss+xml"), .attribute(named: "title", value: "Subscribe to \(site.name)"))
        )
    }
}

try IvanCantarino().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .customFoundation),
    .generateRSSFeed(including: [.posts]),
    .generateSiteMap()
])