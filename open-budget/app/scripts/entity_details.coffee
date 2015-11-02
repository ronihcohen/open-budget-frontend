define(["jquery", "backbone", "models", "templates"], ($, Backbone, models, JST) ->
    class EntityDetailsView extends Backbone.View
            events:
              'click .exemption-expander': 'toggleExemptionDetails'

            initialize: ->
                @model.selectedExemption.on 'change:entity_id', =>
                    eid = @model.selectedExemption.get('entity_id')
                    if eid != ""
                      @entity = new models.Entity(pageModel: window.pageModel, entityId: eid)
                      @entity.doFetch()
                      @entity.on 'ready', => @render()
                    else
                      @$el.css('display','none')

            render: ->
                @$el.css('display','inherit')
                data = @entity.toJSON()
                @$el.html JST.entity_details( data )

                # for each exemption by publisher, build a view and render it, and append it
                # to the table body
                exemptionByPublisherBody = @$el.find('.exemption-table tbody')
                exemptionsByPublisher = @entity.exemptionsByPublisher()
                for exemptionByPublisher in _.values(exemptionsByPublisher)
                    rowView = new ExemptionByPublisherRowView(model: exemptionByPublisher)
                    exemptionByPublisherBody.append(rowView.render().el)
                @$el.find('h3.entity-title span.total').text(Object.keys(exemptionsByPublisher).length);
                @

    class ExemptionByPublisherRowView extends Backbone.View
        events:
            'click .exemption-expander .glyphicon': 'toggleDetails'
        tagName: 'tr'
        initialize: ->
            @detailViews = []
            @initialized = false

        toggleDetails: ->
            if (!@initialized)
              _.each @model.exemptions, (exemption) =>
                    detailView = new ExemptionDetailsRowView(model: exemption)
                    @$el.after(detailView.render().$el)
    #                detailView.showFullDetailsView()
                    @detailViews.push(detailView)
              @initialized = true

            @model.expanded = !@model.expanded
            if(@model.expanded)
                @$el.find('.open').hide()
                @$el.find('.collapse').show()
                @showAllDetailViews()
            else
                @$el.find('.open').show()
                @$el.find('.collapse').hide()
                @hideAllDetailViews()

        showAllDetailViews: ->
            _.each @detailViews, (detailView) =>
                detailView.showFullDetailsView()

        hideAllDetailViews: ->
            _.each @detailViews, (detailView) =>
                detailView.hideFullDetailsView()

        render: ->
            @$el.html JST.exemption_by_publisher_row(@model)
            @$el.find('.collapse').hide()
            @

    class ExemptionDetailsRowView extends Backbone.View
        events:
            'click .exemption-full-details-expander .open': 'toggleDetails'
            'click .exemption-full-details-expander .collapse': 'toggleDetails'
        tagName: 'tr'
        className: 'detailsRow'

        initialize: ->
            @initialized = false

        render: ->
            @$el.html JST.exemption_details_row(@model)
            @$el.find('.open').show()
            @$el.find('.collapse').hide()
            @

        toggleDetails: ->
            if (!@initialized)
              @detailView = new ExemptionFullDetailsView(model: @model)
              @$el.after(@detailView.render().$el)
              @initialized = true

            @model.expanded = !@model.expanded
            if(@model.expanded)
                @$el.find('.open').hide()
                @$el.find('.collapse').show()
                @detailView.toggleShow()
            else
                @$el.find('.collapse').hide()
                @$el.find('.open').show()
                @detailView.toggleHide()

        showFullDetailsView: ->
          @$el.show()

        hideFullDetailsView: ->
          @model.expanded = false
          @$el.find('.collapse').hide()
          @$el.find('.open').show()
          if @detailView?
            @detailView.toggleHide()
          @$el.hide()


    class ExemptionFullDetailsView extends Backbone.View
        tagName: 'tr'
        className: 'fullDetailsRow'

        render: ->
            @$el.html JST.exemption_full_details(@model)
            @

        toggleShow: ->
            @$el.show("0", () =>
              @$el.find("div.exemption-full-details-div").slideDown("slow"))

        toggleHide: ->
            @$el.hide("0", () =>
              @$el.find("div.exemption-full-details-div").slideUp("slow"))

    $(->
        console.log "entity-details"
        if window.pageModel.get("entityId")?
            window.entityDetails = new EntityDetailsView({el: $("#standalone-entity-details"), model: window.pageModel})
            window.pageModel.selectedExemption.set('selected',window.pageModel.get("entity_id"))
    )

    EntityDetailsView
)
