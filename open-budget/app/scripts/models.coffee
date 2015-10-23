define [
    'backbone',
    'main_page_tabs',
    'url_scheme',
    'scripts/modelsHelpers/BudgetItem',
    'scripts/modelsHelpers/ChangeLine',
    'scripts/modelsHelpers/ChangeExplanation',
    'scripts/modelsHelpers/Entity',
    'scripts/modelsHelpers/NewSpendings',
    'scripts/modelsHelpers/PageModel'
  ], (Backbone, main_page_tabs, url_scheme, BudgetItem, ChangeLine, ChangeExplanation, Entity, NewSpendings, PageModel) ->
    dateToTimestamp = (date) ->
        if !date? then return null
        date = date.split('/')
        date = new Date(parseInt(date[2]),parseInt(date[1])-1,parseInt(date[0]))
        date.valueOf()


        # toLocaleJSON: (requestedLocale) ->
        #   locale = requestedLocale || "he"
        #   baseJSON = @toJSON()
        #   resultJSON = {}
        #   pageModel = window.pageModel
        #   for key, value of baseJSON
        #     normalizedKey = pageModel.supportFieldNormalizer.normalize(key, locale)
        #     if normalizedKey?
        #       resultJSON[normalizedKey] = value
        #
        #   return resultJSON

    models = {
        BudgetItem: BudgetItem
        ChangeLine: ChangeLine
        ChangeExplanation: ChangeExplanation
        Entity: Entity
        NewSpendings: NewSpendings
        pageModel: new PageModel()
    }

    # TODO remove all global variables and use dependancies
    window.models = models
    window.pageModel = models.pageModel
    window.pageModel
        .switchView(pageModel.URLSchemeHandlerInstance.linkParameters)

    return models
