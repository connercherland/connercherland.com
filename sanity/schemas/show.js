export default {
  name: 'show',
  title: 'Show',
  type: 'document',
  fields: [
    {
      name: 'venue',
      title: 'Venue',
      type: 'reference',
      to: {type: 'venue'}
    },
    {
      name: 'startTime',
      title: 'Start Time',
      type: 'datetime',
    },
    {
      name: 'endTime',
      title: 'End Time',
      type: 'datetime',
    },
  ],

  preview: {
    select: {
      venue: 'venue.name',
      time: 'startTime'
    },
    prepare: ({venue, time}) => {
      return {
        title: venue,
        subtitle: time
      }
    }
  }
}
