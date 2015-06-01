---
title: Weekly Changelog
date: 2015-05-31 15:47 UTC
tags: changelog
author: Trung Lê
excerpt: >
  Changelog from May 16 2015 to May 31 2015
---

## Releases

  * Released lotusrb 0.3.2
  * Released lotus-controller 0.4.3
  * Released lotus-view 0.4.1
  * Released lotus-model 0.3.2
  * Released lotus-utils 0.4.3
  * Released lotus-validations 0.3.2
  * Released lotus-router 0.4.0
  * Released lotus-helpers 0.1.0

## Completed

  * [[Ngoc Nguyen](https://github.com/nguyenngoc2505)] Action generator doesn't respect Ruby file naming [[details](https://github.com/lotus/lotus/pull/232)]
  * [[Luca Guidi](https://github.com/jodosha)] Don't rely on config.before(:suite) to preload Lotus apps in testing [[details](https://github.com/lotus/lotus/pull/231)]
  * [[Ngoc Nguyen](https://github.com/nguyenngoc2505)] Model generator creates wrong RSpec files [[details](https://github.com/lotus/lotus/pull/230)]
  * [[Alfonso Uceda](https://github.com/AlfonsoUceda)] Added send_file method in action for sending files [[details](https://github.com/lotus/controller/pull/112)]
  * [[Luca Guidi](https://github.com/jodosha)] Introduced #content as API to render optional contents [[details](https://github.com/lotus/view/pull/70)]
  * [[Ngoc Nguyen](https://github.com/nguyenngoc2505)] Model generator doesn't respect Ruby file naming [[details](https://github.com/lotus/lotus/pull/229)]
  * [[François Beausoleil](https://github.com/francois)] Make TypeError messages even more useful [[details](https://github.com/lotus/utils/pull/79)]
  * [[Alfonso Uceda](https://github.com/AlfonsoUceda)] Enhanced cookies syntax options [[details](https://github.com/lotus/lotus/pull/227)]
  * [[deepj](https://github.com/deepj)] Introduce invalid? method as an opposite to valid? [[details](https://github.com/lotus/validations/pull/64)]
  * [[Alfonso Uceda](https://github.com/AlfonsoUceda)] Fixed action generator, raise exception if action name isn't supplied [[details](https://github.com/lotus/lotus/pull/223)]
  * [[Dmitry Tymchuk](https://github.com/dsnipe)] Fix for Dirty tracking inplace modifications [[details](https://github.com/lotus/model/pull/187)]
  * [[Alfonso Uceda](https://github.com/AlfonsoUceda)] Add automatic :secure option [[details](https://github.com/lotus/lotus/pull/222)]
  * [[deepj](https://github.com/deepj)] Test only against JRuby 9k on Travis [[details](https://github.com/lotus/view/pull/67)]
  * [[deepj](https://github.com/deepj)] Fix failling deprecation_test.rb under JRuby 9000 [[details](https://github.com/lotus/utils/pull/78)]
  * [[Alfonso Uceda](https://github.com/AlfonsoUceda)] Added automatically expires option if max_age option presents [[details](https://github.com/lotus/controller/pull/110)]
  * [[Jeremy Friesen](https://github.com/jeremyf)] Wordsmithing README [[details](https://github.com/lotus/controller/pull/109)]
  * [[Jeremy Friesen](https://github.com/jeremyf)] Wordsmithing [[details](https://github.com/lotus/validations/pull/63)]
  * [[Alfonso Uceda](https://github.com/AlfonsoUceda)] Rack::Lint compatibility [[details](https://github.com/lotus/controller/pull/108)]
  * [[Jeremy Friesen](https://github.com/jeremyf)] Wordsmithing [[details](https://github.com/lotus/model/pull/185)]
  * [[Jeremy Friesen](https://github.com/jeremyf)] Wordsmithing the REAMDE.md typo [[details](https://github.com/lotus/validations/pull/62)]
  * [[Alfonso Uceda](https://github.com/AlfonsoUceda)] Added routing helpers to actions [[details](https://github.com/lotus/lotus/pull/219)]
  * [[Peter Berkenbosch](https://github.com/peterberkenbosch)] Add raw SQL support with execute() [[details](https://github.com/lotus/model/pull/184)]
  * [[Mohammed Aqnouch](https://github.com/maqnouch)] Fix typos [[details](https://github.com/lotus/lotus/pull/217)]
  * [[Ngoc Nguyen](https://github.com/nguyenngoc2505)] Add Lotus.env [[details](https://github.com/lotus/lotus/pull/216)]
  * [[Luca Guidi](https://github.com/jodosha)] When coerce Utils::Attributes to Hash don't rely on #to_h of the single values [[details](https://github.com/lotus/utils/pull/76)]
  * [[Steffen Schildknecht](https://github.com/stsc3000)] Add missing Lotus::Interactor include in examples [[details](https://github.com/lotus/utils/pull/75)]
  * [[Luca Guidi](https://github.com/jodosha)] Fix internet explorer HTTP accept [[details](https://github.com/lotus/controller/pull/105)]
  * [[Luca Guidi](https://github.com/jodosha)] Ensure Attributes#to_h to force Hash values [[details](https://github.com/lotus/utils/pull/74)]
  * [[Luca Guidi](https://github.com/jodosha)] Ensure nested attributes to have correct Hash serialization. [[details](https://github.com/lotus/validations/pull/60)]
  * [[Team Leo](https://github.com/LeoTeam)] Refactor update timestamps [[details](https://github.com/lotus/model/pull/182)]

## Development

  * [[Serdar Dogruyol](https://github.com/Sdogruyol)] Add Platform Control for Code Reloading [[details](https://github.com/lotus/lotus/pull/238)]
  * [[Sung Won Cho](https://github.com/sungwoncho)] Add Destroy command [[details](https://github.com/lotus/lotus/pull/194)]
  * [[Maciej Malecki](https://github.com/smt116)] Preload application in config/environment file. [[details](https://github.com/lotus/lotus/pull/180)]
  * [[Vinícius Oliveira](https://github.com/vinioliveira)] CLI db migrate/rollback  [[details](https://github.com/lotus/lotus/pull/161)]
  * [[Cole](https://github.com/thecatwasnot)] Adding migration generator [[details](https://github.com/lotus/lotus/pull/139)]
  * [[Trung Lê](https://github.com/joneslee85)] Add Lotus::Model::Migration [[details](https://github.com/lotus/model/pull/144)]
  * [[Luca Guidi](https://github.com/jodosha)] Implement SQL inner join [[details](https://github.com/lotus/model/pull/102)]
  * [[Uku Taht](https://github.com/heruku)] Associations [[details](https://github.com/lotus/model/pull/56)]
  * [[Marcin Olichwirowicz](https://github.com/rodzyn)] Custom validations [[details](https://github.com/lotus/validations/pull/49)]
  * [[Luca Guidi](https://github.com/jodosha)] Form helper [[details](https://github.com/lotus/helpers/pull/16)]
  * [[Tom Kadwill](https://github.com/tomkadwill)] Number formatting helper [[details](https://github.com/lotus/helpers/pull/11)]
  * [[Fuad Saud](https://github.com/fuadsaud)] Add helper for word wrapping [[details](https://github.com/lotus/helpers/pull/1)]

## Roadmap

[Trello board](http://bit.ly/lotusrb-roadmap)

