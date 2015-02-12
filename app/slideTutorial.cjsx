React = require 'react/addons'
cx = React.addons.classSet

slideTutorials = require './lib/slideTutorials'

SlideTutorial = React.createClass
  displayName: 'SlideTutorial'

  getInitialState: ->
    general: slideTutorials.general
    chimps: [
      {image: 'http://placehold.it/400x275', title: 'Chimp Slide 1', content: 'Lorem ipsum dolor sit amet, mel ne idque evertitur ullamcorper, ne scaevola efficiantur nec, nobis menandri explicari te eos. Sea no munere laudem. Ne vis eripuit pericula hendrerit, diam veri aliquando vim ea. Eu prompta recusabo eum.', button: 'Next'}
      {image: 'http://placehold.it/400x275', title: 'Chimp Slide 2', content: 'Lorem ipsum dolor sit amet, mel ne idque evertitur ullamcorper, ne scaevola efficiantur nec, nobis menandri explicari te eos. Sea no munere laudem. Ne vis eripuit pericula hendrerit, diam veri aliquando vim ea. Eu prompta recusabo eum.', button: 'Next'}
      {image: 'http://placehold.it/400x275', title: 'Chimp Slide 3', content: 'Lorem ipsum dolor sit amet, mel ne idque evertitur ullamcorper, ne scaevola efficiantur nec, nobis menandri explicari te eos. Sea no munere laudem. Ne vis eripuit pericula hendrerit, diam veri aliquando vim ea. Eu prompta recusabo eum.', button: 'Finish'}
    ]
    activeSlide: 0

  componentWillReceiveProps: (nextProps) ->
    if nextProps.tutorialIsOpen is false
      @setState activeSlide: 0

  onClickButton: ->
    switch
      when @state.activeSlide < @state[@props.tutorialType]?.length - 1
        @setState activeSlide: @state.activeSlide + 1
      when @state.activeSlide is @state[@props.tutorialType]?.length - 1
        @onClickCloseTutorial()

  onClickCloseTutorial: ->
    slideTutorial = @refs.slideTutorial.getDOMNode()
    slideTutorial.classList.add 'fade-out' #css fade-out animation cause js animations aren't great in react yet.

    #Wait for animation
    setTimeout ( =>
      slideTutorial.classList.remove 'fade-out'
      @props.closeTutorial()
    ), 250

  onDotClick: (i) ->
    @setState activeSlide: i

  render: ->
    slideDots = @state[@props.tutorialType]?.map (slide, i) =>
      dotClasses = cx
        'slide-tutorial-dot': true
        'active': i is @state.activeSlide

      <div key={i} className={dotClasses} onClick={@onDotClick.bind(null, i)}></div>

    slides = @state[@props.tutorialType]?.map (slide, i) =>
      slideClasses = cx
        'slide-tutorial-slide': true
        'active': i is @state.activeSlide

      <div key={i} className={slideClasses}>
        <div className="slide-tutorial-slide-top">
          <img src={slide.image} />
        </div>
        <div className="slide-tutorial-slide-bottom">
          <h1>{slide.title}</h1>
          <p>{slide.content}</p>
        </div>
        <div className="slide-tutorial-button-container">
          <button className="slide-tutorial-next-button" onClick={@onClickButton} value={slide.button}>{slide.button}</button>
        </div>
        <div className="slide-tutorial-dots">
          {slideDots}
        </div>
      </div>

    slideTutorialClasses = cx
      'slide-tutorial': true
      'show': @props.tutorialIsOpen

    overlayHeight = if @props.tutorialIsOpen is true
      # modifying height since footer and topbar exist outside of React's virtual DOM
      height: document.getElementById('footer').clientHeight + document.getElementsByClassName('classify')[0].clientHeight + 100

    <div ref="slideTutorial" className={slideTutorialClasses} style={overlayHeight}>
      <div  className="slide-tutorial-container">
        <button className="slide-tutorial-close-button" onClick={@onClickCloseTutorial}>x</button>
        {slides}
      </div>
    </div>

module.exports = SlideTutorial