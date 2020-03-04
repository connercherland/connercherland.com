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
      validation: Rule => Rule.required(),
      options: {
        dateFormat: 'YYYY-MM-DD',
        timeFormat: 'hh:mma',
        timeStep: 30,
        calendarTodayLabel: 'Today'
      }
    },
    {
      name: 'endTime',
      title: 'End Time',
      type: 'datetime',
      validation: Rule => Rule.required().min(Rule.valueOfField('startTime')),
      options: {
        dateFormat: 'YYYY-MM-DD',
        timeFormat: 'hh:mma',
        timeStep: 30,
        calendarTodayLabel: 'Today'
      }
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
        subtitle: time ? formatDate(new Date(time)) : ''
      }
    }
  }
}

function formatDate(date) {
  const options = {
    hour: 'numeric', minute: 'numeric',
    timeZone: 'America/Los_Angeles',
    timeZoneName: 'short', weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' 
  };
  return new Intl.DateTimeFormat('en-US', options).format(date);
}