/// Fictional content for demonstration. Replace after Product Owner approval.
class Exhibition {
  const Exhibition({required this.id, required this.title, required this.category,
    required this.location, required this.summary, required this.story,
    required this.duration, required this.art});
  final String id, title, category, location, summary, story;
  final int duration, art;
}

const exhibitions = [
  Exhibition(id: 'design', title: 'Everyday, extraordinary', category: 'Design',
    location: 'Sample gallery A · Level 2', duration: 20, art: 0,
    summary: 'Small objects. Big ideas. A fresh look at the things around us.',
    story: 'A chair, a lamp, a radio: everyday objects can reveal how people lived and what they imagined for the future. This fictional exhibition invites you to look closely at shape, material, and function.\n\nLook for one object you recognize. How might its design change the way you use it?'),
  Exhibition(id: 'print', title: 'Messages in motion', category: 'Graphic art',
    location: 'Sample gallery B · Level 2', duration: 15, art: 1,
    summary: 'Explore how type, color, and images move an idea into the world.',
    story: 'Printed images turn walls, books, and streets into places for sharing ideas. This fictional exhibition explores the choices that give a message its power.\n\nCompare two designs. What catches your eye first, and what makes you keep looking?'),
  Exhibition(id: 'architecture', title: 'Imagining tomorrow', category: 'Architecture',
    location: 'Sample gallery C · Level 3', duration: 25, art: 2,
    summary: 'Buildings and spaces that ask us to imagine a different future.',
    story: 'Architecture expresses hopes for how a community might live. This fictional exhibition brings together imagined spaces and bold geometric forms.\n\nFind a space that feels welcoming. Which design choices create that feeling?'),
];

class MuseumProgram {
  const MuseumProgram(this.title, this.detail, this.location);
  final String title, detail, location;
}
const programs = [
  MuseumProgram('A closer look: design', 'Sample guided conversation · Schedule to be confirmed', 'Visitor services'),
  MuseumProgram('Make your own message', 'Sample creative workshop · Availability to be confirmed', 'Sample learning space'),
];

class RouteStop {
  const RouteStop(this.title, this.instruction, this.floor);
  final String title, instruction;
  final int floor;
}
const designRoute = [
  RouteStop('Begin at visitor services', 'Ask staff to confirm gallery locations and an accessible route.', 1),
  RouteStop('Everyday, extraordinary', 'Explore how objects combine beauty and purpose in sample gallery A.', 2),
  RouteStop('Messages in motion', 'Compare the visual messages in sample gallery B.', 2),
  RouteStop('Reflect on your visit', 'Return to visitor services for more ideas to explore.', 1),
];
